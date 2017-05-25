class AgreementsController < ApplicationController
  before_action :admin_required, only: [:destroy, :touch]
  before_action :find_agreement, only: [:upvote, :update, :touch, :destroy]
  before_action :set_back_url_to_current_page, only: :show
  before_action :check_if_spam, only: :add_supporter
  before_action :find_statement, only: :add_supporter

  def upvote
    if upvote = Upvote.where(agreement: @agreement, individual: current_user).first
      upvote.destroy
      flash[:notice] = "Upvote removed!"
    else
      Upvote.create(agreement: @agreement, individual: current_user)
      flash[:notice] = "Upvoted!"
    end
    @agreement.update_attribute(:upvotes_count, @agreement.upvotes.count)
    redirect_to statement_path(@agreement.statement)
  end

  def update
    if @agreement.individual == current_user || admin?
      @agreement.update_attributes(params[:agreement].permit(:reason, :url, :reason_category_id ))
      respond_to do |format|
        format.html { redirect_to(get_and_delete_back_url || statement_path(@agreement.statement)) }
        format.js { render json: @agreement.to_json, status: :ok }
      end
    else
      redirect_to(get_and_delete_back_url || root_path, notice: "Access denied")
    end
  end

  def touch
    @agreement.touch if @agreement
    redirect_to(get_and_delete_back_url || root_path)
  end

  def destroy
    statement = @agreement.statement
    @agreement.destroy
    redirect_to(get_and_delete_back_url || statement_path(statement))
  end

  def add_supporter
    voter = find_or_create_voter!
    LogMailer.log_email("@#{current_user.try(:twitter)}, email: #{params[:email]}, ip: #{request.remote_ip} added #{voter.name} (@#{voter.try(:twitter)}) to '#{@statement.content}'").deliver
    cast_vote(voter)
    expire_fragment "brexit_board" if @statement.brexit?
    session[:added_voter] = voter.hashed_id if voter.twitter.present?
    redirect_to back_url_with_no_parameters || statement_path(@statement), notice: "Done"
  end

  def show
    @agreement = Agreement.find_by_hashed_id(params[:id])
    @agreement_comment = AgreementComment.new
  end

  private

  def find_or_create_voter!
    Voter.new(
      name: twitter ? nil : params[:name],
      twitter: twitter.try(:downcase),
      profession_id: params[:profession_id],
      current_user: current_user,
      wikipedia: params[:wikipedia],
      bio: params[:biography],
      picture: params[:picture_from_url]
    ).find_or_create!
  end

  def cast_vote(voter)
    Agreement.create(
      statement_id: params[:statement_id],
      individual_id: voter.id,
      url: params[:source],
      reason: params[:comment].present? ? params[:comment] : nil,
      reason_category_id: params[:reason_category_id],
      extent: params[:commit] == "She/he disagrees" ? 0 : 100,
      added_by_id: added_by_id(params[:email].try(:strip)).try(:id)
    )
  end

  def find_statement
    @statement = Statement.find(params[:statement_id])
  end

  def twitter
    @twitter ||= (twitter? ? params[:name].gsub("@", "") : nil)
  end

  def check_if_spam
    if spam?
      render status: 401, plain: "Your message has to be approved because it seemed spam. Sorry for the inconvenience."
      LogMailer.log_email("spam? params: #{params.inspect}").deliver unless statement_used_by_spammers?
    end
  end

  def spam? # real people have name and surname separated by a space
    !twitter? && !first_and_surname?
  end

  def twitter?
    params[:name][0] == "@"
  end

  def first_and_surname?
    params[:name] =~ /\ /
  end

  def statement_used_by_spammers?
    params[:statement_id] == "113"
  end

  def find_agreement
    @agreement = Agreement.find_by_hashed_id(params[:id])
  end

  def added_by_id(email)
    if current_user
      current_user
    elsif email.present?
      Individual.find_by_email(email) || Individual.create(email: email)
    end
  end
end

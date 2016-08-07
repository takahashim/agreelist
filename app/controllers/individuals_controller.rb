class IndividualsController < ApplicationController
  before_action :login_required, only: [:update, :save_email]
  before_action :load_individual, except: [:save_email, :new, :create]
  before_action :has_update_individual_rights?, only: :update

  def new
    @individual = Individual.new
  end

  def create
    @individual = Individual.new(params.require(:individual).permit(:email, :password, :password_confirmation, :is_user))
    if @individual.save
      @individual.send_activation_email
      session[:user_id] = @individual.id
      redirect_to edit_individual_path(@individual, back_url: params[:back_url] || root_path)
    else
      render action: :new
    end
  end

  def activation
    @individual = Individual.find_by_activation_digest(params[:id])
    if @individual
      @individual.activate
      flash[:notice] = "Your account has been activated"
      redirect_to root_path
    else
      flash[:notice] = "Error activating your account"
      redirect_to current_user ? root_path : login_path
    end
  end

  def show
    @agrees = @individual.agrees
    @disagrees = @individual.disagrees
  end

  def edit
  end

  def update
    params[:individual][:name] = nil if params[:individual][:name] == ""
    if admin?
      result = @individual.update_attributes(params.require(:individual).permit(:name, :twitter, :email, :bio, :picture_from_url, :ranking, :profession_id))
    else
      result = @individual.update_attributes(params.require(:individual).permit(:name, :bio, :picture_from_url, :profession_id))
    end
    if result
      respond_to do |format|
        format.json { render status: 200, json: @individual }
        format.html { redirect_to(params[:back_url].present? ? params[:back_url].gsub(" ", "+") : "/#{@individual.to_param}", notice: 'Successfully updated.') }
      end
    else
      render action: "edit"
    end
  end

  def save_email
    if current_user.update_attributes(params.require(:individual).permit(:email))
      back = params[:back].try(:keys).try(:first)
      redirect_to back.try(:present?) ? back : root_path
    else
      render action: "edit"
    end
  end

  private

  def load_individual
    @individual = Individual.where('lower(twitter) = ?', params[:id].downcase).first || Individual.find_by_hashed_id(params[:id].gsub("user-", ""))
  end
end

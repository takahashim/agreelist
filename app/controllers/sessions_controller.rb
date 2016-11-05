class SessionsController < ApplicationController
  rescue_from ActionController::RedirectBackError, with: :redirect_to_default

  def new
  end

  def create
    if individual.try(:authenticate, params[:password])
      session[:user_id] = individual.id
      redirect_to params[:back_url] || root_url, :notice => "Logged in!"
    else
      flash.now[:error] = "Invalid email or password"
      render "new"
    end
  end

  def create_with_twitter
    auth = request.env["omniauth.auth"]
    user = Individual.find_by_twitter(auth["info"]["nickname"].downcase) || Individual.create_with_omniauth(auth)
    session[:user_id] = user.id
    LogMailer.log_email("#{user.name} (@#{user.twitter}) just signed in!").deliver
    if params["task"] == "voting"
      vote = Vote.new(
        statement_id: params["statement_id"],
        individual_id: user.id,
        extent: params["vote"] == "agree" ? 100 : 0
      ).vote!
      redirect_to(edit_reason_path(vote, back_url: params[:back_url]))
    elsif params["task"] == "post"
      s = Statement.create(content: params["content"], individual_id: user.id)
      Vote.new(
        statement_id: s.id,
        individual_id: user.id,
        extent: 100
      ).vote!
      redirect_to(params[:back_url] || root_path, notice: "Signed in!")
    elsif params["task"] == "upvote"
      agreement = Agreement.find(params["agreement_id"])
      if Upvote.exists?(individual: current_user, agreement: agreement)
        redirect_to(params[:back_url] || root_path, notice: "Already was upvoted!")
      else
        Upvote.create(individual: current_user, agreement: agreement)
        agreement.update_attribute(:upvotes_count, agreement.upvotes.count)
        redirect_to(params[:back_url] || root_path, notice: "Upvoted!")
      end
    else
      redirect_to(params[:back_url] || root_path, notice: "Signed in!")
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, :notice => "Thanks for stopping by. See you soon!"
  end

  private

  def redirect_to_default
    redirect_to root_path
  end

  def individual
    Individual.find_by_email(params[:email]) if params[:email].present?
  end
end

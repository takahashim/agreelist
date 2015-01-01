class SessionsController < ApplicationController
  def create
    auth = request.env["omniauth.auth"]
    user = Individual.find_by_twitter(auth["info"]["nickname"]) || Individual.create_with_omniauth(auth)
    session[:user_id] = user.id
    redirect_to user.email.present? ? root_url : "/join", :notice => "Signed in!"
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Signed out!"
  end
end

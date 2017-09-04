class ResetPasswordController < ApplicationController
  before_action :find_user_from_digest, only: [:edit, :update]
  def new
  end

  def create
    @user = params[:forgot][:email].present? ? Individual.find_by_email(params[:forgot][:email].downcase) : nil
    if @user
      ResetPassword.new(@user).reset!
      redirect_to login_path, notice: "Email sent with instructions to reset your password"
    else
      flash.now[:error] = "Email address not found"
      render 'new'
    end
  end

  def edit
    @key = params[:id]
  end

  def update
    if @individual.update_attributes(params.require(:reset_password).permit(:password, :password_confirmation))
      session[:user_id] = @individual.id
      flash[:notice] = "Your password has been changed"
      redirect_to get_and_delete_back_url || root_path
    else
      @key = params[:id]
      flash.now[:error] = @individual.errors.full_messages.join("\n")
      render action: :edit
    end
  end

  private

  def find_user_from_digest
    @individual = Individual.find_by_reset_digest(params[:id])
  end
end

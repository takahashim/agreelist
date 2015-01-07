class IndividualsController < ApplicationController
  before_action :login_required, only: [:update, :save_email]
  before_action :load_individual, except: :save_email
  before_action :same_user_required, only: :save_email
  before_action :admin_required, only: :update

  def show
    @agrees = @individual.agrees
    @disagrees = @individual.disagrees
  end

  def edit
  end

  def update
    if @individual.update_attributes(params.require(:individual).permit(:name, :twitter, :email))
      redirect_to root_path, notice: 'Successfully updated.'
    else
      render action: "edit"
    end
  end

  def save_email
    if current_user.update_attributes(params.require(:individual).permit(:email))
      redirect_to "/statement", notice: 'Email saved.'
    else
      render action: "edit"
    end
  end

  private

  def load_individual
    @individual = Individual.find(params[:id])
  end

  def same_user_required
    redirect_to root_path, notice: "You can't edit other user's profile"  if @individual != current_user && !admin?
  end
end

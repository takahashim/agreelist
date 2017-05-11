class FollowsController < ApplicationController
  before_action :login_required
  before_action :find_statement

  def create
    current_user.follow(@object)
    redirect_back
  end

  def destroy
    current_user.stop_following(@object)
    redirect_back
  end

  private

  def find_statement
    if params[:statement_id]
      @object = Statement.find(params[:statement_id])
    elsif params[:individual_id]
      @object = Individual.find(params[:individual_id])
    end
  end
end

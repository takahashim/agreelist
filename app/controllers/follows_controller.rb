class FollowsController < ApplicationController
  before_action :login_required
  before_action :find_statement
  attr_reader :fallback_location

  def create
    current_user.follow(@object)
    redirect_back(fallback_location: fallback_location)
  end

  def destroy
    current_user.stop_following(@object)
    redirect_back(fallback_location: fallback_location)
  end

  private

  def find_statement
    if params[:statement_id]
      @object = Statement.find(params[:statement_id])
    elsif params[:individual_id]
      @object = Individual.find(params[:individual_id])
    end
    @fallback_location = statement_path(@object)
  end
end

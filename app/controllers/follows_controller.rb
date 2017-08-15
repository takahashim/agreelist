class FollowsController < ApplicationController
  before_action :login_required
  before_action :find_statement

  def create
    current_user.follow(@object)
    LogMailer.log_email("@#{current_user.try(:twitter)}, email: #{params[:email]}, ip: #{request.remote_ip} followed '#{@object.to_s}'").deliver
    redirect_to(get_and_delete_back_url || statement_path(@object))
  end

  def destroy
    current_user.stop_following(@object)
    LogMailer.log_email("@#{current_user.try(:twitter)}, email: #{params[:email]}, ip: #{request.remote_ip} stopped following '#{@object.to_s}'").deliver
    redirect_to(get_and_delete_back_url || statement_path(@object))
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

class NewController < ApplicationController
  def index
    if params[:all]
      @agreements = Agreement.order(updated_at: :desc).page(params[:page] || 1).per(50).includes(:statement).includes(:individual)
    else
      @agreements = Agreement.select('DISTINCT ON (statement_id) statement_id, id, updated_at, individual_id, extent, hashed_id, reason').order("statement_id, updated_at DESC").page(params[:page] || 1).per(50).includes(:statement).includes(:individual)
    end
    @statement = Statement.new
  end

  def vote
    agreement = Agreement.where(statement_id: params[:statement_id], individual_id: current_user.id).first
    if agreement
      agreement.extent = extent
    else
      agreement = Agreement.new(
        statement_id: params[:statement_id],
        individual_id: current_user.id,
        extent: params[:vote] == "agree" ? 100 : 0)
    end
    agreement.save
    redirect_to edit_reason_path(agreement, back_url: params[:back_url]) || new_path
  end

  private

  def extent
    params[:vote] == "agree" ? 100 : 0
  end
end

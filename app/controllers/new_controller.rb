class NewController < ApplicationController
  def index
    if params[:all]
      @agreements = Agreement.order(updated_at: :desc).page(params[:page] || 1).per(50).includes(:statement).includes(:individual)
    else
      one_agreement_per_statement = Statement.select(:id, :content, :hashed_id).all.map{|s| s.agreements.last}.compact
      @agreements = Kaminari.paginate_array(one_agreement_per_statement.sort_by{|a| a.updated_at}.reverse!).page(params[:page] || 1).per(50)
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

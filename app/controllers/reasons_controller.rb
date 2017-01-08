class ReasonsController < ApplicationController
  def edit
    @agreement = Agreement.find_by_hashed_id(params[:id])
  end

  def update
    # do we use this or agreements#update?
    if @agreement.individual == current_user || admin?
      a = Agreement.update_attributes(params.require(@agreement).permit(:reason, :url))
      redirect_to(params[:back_url] || root_path, notice: "Vote/opinion added")
    else
      redirect_to(params[:back_url] || root_path, error: "Permission denied")
    end
  end
end

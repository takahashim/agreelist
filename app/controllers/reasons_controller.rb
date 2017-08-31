class ReasonsController < ApplicationController
  before_action :load_agreement
  before_action :admin_required, unless: :current_user_or_admin?

  def edit
  end

  def update
    a = Agreement.update_attributes(params.require(@agreement).permit(:reason, :url))
    redirect_to(get_and_delete_back_url || root_path, notice: "Vote/opinion added")
  end

  private

  def load_agreement
    @agreement = Agreement.find_by_hashed_id(params[:id])
  end

  def current_user_or_admin?
    @agreement.individual == current_user || admin?
  end
end

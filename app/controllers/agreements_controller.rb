class AgreementsController < ApplicationController
  before_action :admin_required

  def destroy
    @agreement = Agreement.find(params[:id])
    statement = @agreement.statement
    @agreement.destroy
    redirect_to statement_path(statement)
  end
end

class AgreementsController < ApplicationController
  http_basic_authenticate_with name: "hector", password: "perez"
  def destroy
    @agreement = Agreement.find(params[:id])
    statement_id = @agreement.statement_id
    @agreement.destroy

    redirect_to statement_path(statement_id)
  end
end

class IndividualsController < ApplicationController
  before_action :admin_required, only: :update

  def show
    @individual = Individual.find(params[:id])
    @agrees = @individual.agrees
    @disagrees = @individual.disagrees
  end

  def edit
    @individual = Individual.find(params[:id])
  end

  def update
    @individual = Individual.find(params[:id])

    if @individual.update_attributes(params.require(:individual).permit(:name, :twitter, :email))
      redirect_to root_path, notice: 'Successfully updated.'
    else
      render action: "edit"
    end
  end


end

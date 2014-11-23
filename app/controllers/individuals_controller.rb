class IndividualsController < ApplicationController
  http_basic_authenticate_with name: "hector", password: "perez", only: ["edit", "update"]

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

    respond_to do |format|
      if @individual.update_attributes(params[:individual])
        format.html { redirect_to @individual, notice: 'Statement was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @individual.errors, status: :unprocessable_entity }
      end
    end
  end


end

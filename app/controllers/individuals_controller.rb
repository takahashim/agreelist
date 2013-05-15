class IndividualsController < ApplicationController
  def show
    @individual = Individual.find(params[:id])
    @agrees = @individual.agrees
    @disagrees = @individual.disagrees
  end
end

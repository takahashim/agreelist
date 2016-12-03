class OccupationsController < ApplicationController
  def index
    @occupations = Individual.tag_counts_on(:occupations).sort_by{|t| - t.taggings_count}
  end

  def show
    @occupation = params[:id].gsub("_", " ")
    @individuals = Individual.tagged_with(@occupation, on: :occupations)
  end
end
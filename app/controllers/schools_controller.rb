class SchoolsController < ApplicationController
  def index
    @schools = Individual.tag_counts_on(:schools).sort_by{|t| - t.taggings_count}
  end

  def show
    @school = params[:id].gsub("_", " ")
    @individuals = Individual.tagged_with(@school, on: :schools)
  end
end
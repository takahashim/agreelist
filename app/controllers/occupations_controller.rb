class OccupationsController < ApplicationController
  before_action :set_back_url_to_current_page, only: [:index, :show]

  def index
    @occupations = Individual.tag_counts_on(:occupations).sort_by{|t| - t.taggings_count}
  end

  def show
    @occupation = params[:id].gsub("_", " ")
    @agreements = Agreement.
      joins("left join taggings on taggings.taggable_id=agreements.individual_id left join tags on tags.id=taggings.tag_id").
      where(taggings: {taggable_type: "Individual", context: "occupations"}, tags: {name: @occupation}).
      order("case when agreements.reason != '' AND agreements.reason is not null THEN 1 END ASC,
             case when agreements.reason is null THEN 0 END ASC").
      order(updated_at: :desc).
      page(params[:page] || 1).per(50)
  end
end

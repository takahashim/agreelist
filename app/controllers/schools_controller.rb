class SchoolsController < ApplicationController
  before_action :set_back_url_to_current_page, only: [:index, :show]

  def index
    @schools = Individual.tag_counts_on(:schools).sort_by{|t| - t.taggings_count}
    load_occupations_and_schools(number: 7, min_count: 50)
  end

  def show
    @school = params[:id].gsub("-", " ")
    @agreements = Agreement.
      joins("left join taggings on taggings.taggable_id=agreements.individual_id left join tags on tags.id=taggings.tag_id").
      where(taggings: {taggable_type: "Individual", context: "schools"}).
      where("lower(tags.name) = ?", @school).
      order("case when agreements.reason != '' AND agreements.reason is not null THEN 1 END ASC,
             case when agreements.reason is null THEN 0 END ASC").
      order(updated_at: :desc).
      page(params[:page] || 1).per(50)
    load_occupations_and_schools(number: 7, min_count: 50)
  end
end

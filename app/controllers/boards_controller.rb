class BoardsController < ApplicationController
  before_action :set_back_url_to_current_page

  def brexit
    @statement = main_statement
    categories = ReasonCategory.includes(:agreements)
    @categories_in_favor = categories.where(agreements: {extent: 100}).sort_by{|c| - c.agreements.size}
    @categories_against = categories.where(agreements: {extent: 0}).sort_by{|c| - c.agreements.size}
    agreements = Agreement.where(statement: @statement)
    @votes_in_favor = agreements.where(agreements: {extent: 100}).count
    @votes_against = agreements.where(agreements: {extent: 0}).count
    @percentage_in_favor = (@votes_in_favor * 100.0 / (@votes_in_favor + @votes_against)).round
  end
end

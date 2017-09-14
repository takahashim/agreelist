class SearchesController < ApplicationController
  def new
  end

  def create
    @statements = Statement.where("content ilike ?", "%#{params[:search]}%").select("count(agreements.id) as opinions_count, statements.id, statements.url, statements.content").joins(:agreements).group("statements.id").order("opinions_count DESC").to_a
        # @statements = Statement.where("content ilike ?", "%#{params[:search]}%").select("count(agreements.id) as opinions_count, statements.id, statements.url, statements.content").joins(:agreements).where("agreements.reason is not null and agreements.reason != ''").group("statements.id").order("opinions_count DESC").to_a

    @individuals = Individual.where("name ilike ?", "%#{params[:search]}%")
    @agreements = Agreement.where("reason ilike ?", "%#{params[:search]}%").order(upvotes_count: :desc).order(upvotes_count: :desc)
  end
end

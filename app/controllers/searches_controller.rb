class SearchesController < ApplicationController
  def new
  end

  def create
    @statements = Statement.where("content ilike ?", "%#{params[:search]}%").select("statements.id, statements.opinions_count, statements.url, statements.content").group("statements.id").order("opinions_count DESC").to_a
    @individuals = Individual.where("name ilike ?", "%#{params[:search]}%")
    @agreements = Agreement.where("reason ilike ?", "%#{params[:search]}%").order(upvotes_count: :desc).order(upvotes_count: :desc)
  end
end

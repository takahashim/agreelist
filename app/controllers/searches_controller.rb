class SearchesController < ApplicationController
  def new
  end

  def create
    @statements = Statement.where("content ilike ?", "%#{params[:search]}%")
    @individuals = Individual.where("name ilike ?", "%#{params[:search]}%")
    @agreements = Agreement.where("reason ilike ?", "%#{params[:search]}%").order(upvotes_count: :desc)
  end
end

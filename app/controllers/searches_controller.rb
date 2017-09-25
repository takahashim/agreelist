class SearchesController < ApplicationController
  def new
    if params[:q]
      @statements = Statement.where("content ilike ?", "%#{params[:q]}%").select("statements.id, statements.opinions_count, statements.url, statements.content").group("statements.id").order("opinions_count DESC").to_a
      @individuals = Individual.where("name ilike ?", "%#{params[:q]}%")
      @agreements = Agreement.where("reason ilike ?", "%#{params[:q]}%").order(upvotes_count: :desc).order(upvotes_count: :desc)
      @page_type = 'search results page'
    end
  end

  def create
    if params[:search].present?
      redirect_to search_path(q: params[:search])
    else
      flash.now[:notice] = "Search field can't be empty"
      render action: :new
    end
  end
end

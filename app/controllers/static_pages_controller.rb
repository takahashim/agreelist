class StaticPagesController < ApplicationController
  def home
    @statements = Statement.where("individual_id is not null").limit(6)
  end

  def contact
  end
end

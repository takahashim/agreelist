class StaticPagesController < ApplicationController
  def home
    @statements = Statement.joins(:agreements).where("agreements.id is not null").limit(6)
  end

  def contact
  end
end

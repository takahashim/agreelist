class StaticPagesController < ApplicationController
  def home
    @statements = Statement.all(limit: 3)
  end
end

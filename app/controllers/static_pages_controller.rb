class StaticPagesController < ApplicationController
  def home
    @statements = [1, 3, 4, 5, 6, 7].map{ |s| Statement.find(s) }
    # @statements = [1, 2, 3, 1, 2, 3].map{ |s| Statement.find(s) }
  end

  def contact
  end
end

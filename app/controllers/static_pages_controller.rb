class StaticPagesController < ApplicationController
  def home
    if Rails.env == "production"
      @statements = [1, 3, 4, 5, 6, 7].map{ |s| Statement.find(s) }
    else
      @statements = [1, 1, 1, 1, 1, 1].map{ |s| Statement.find(s) }
    end
    # @statements = [1, 2, 3, 1, 2, 3].map{ |s| Statement.find(s) }
  end

  def contact
  end
end

class StaticPagesController < ApplicationController
  def home
    @statements = [1, 3, 8, 5, 6, 7].map{ |s| Statement.find(s) }
    @individuals = [5, 6, 1, 18, 17, 11].map{ |i| Individual.find(i) }
  end

  def contact
  end
end

class StaticPagesController < ApplicationController
  def home
    if Rails.env == "test"
      @statements, @individuals = [], []
      6.times do
        @statements << Statement.find(1)
        @individuals << Individual.find(1)
      end
    else
      @statements = [1, 3, 8, 5, 6, 7].map{ |s| Statement.find(s) }
      @individuals = [5, 6, 1, 18, 17, 11].map{ |i| Individual.find(i) }
    end
  end

  def contact
  end
end

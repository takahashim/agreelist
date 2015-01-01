class StaticPagesController < ApplicationController
  def join
    @individual = current_user
  end

  def home
    if Rails.env == "test"
      @statements, @individuals = [], []
      9.times do
        @statements << Statement.first
        @individuals << Individual.first
      end
    else
      @statements = [1, 3, 8, 5, 6, 7, 15, 13, 14].map{ |s| Statement.find(s) }
      @individuals = [5, 6, 1, 18, 17, 12, 25, 23, 24].map{ |i| Individual.find(i) }
    end
    @statement = Statement.new if current_user
  end

  def contact
  end
end

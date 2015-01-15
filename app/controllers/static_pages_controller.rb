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
      @statements = [15, 80, 8, 5, 6, 7, 1, 13, 24].map{ |s| Statement.find(s) }
      @individuals = [25, 20, 1, 18, 17, 12, 5, 23, 38].map{ |i| Individual.find(i) }
    end
    @statement = Statement.new if current_user
  end

  def contact
  end
end

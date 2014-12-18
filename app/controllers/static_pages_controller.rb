class StaticPagesController < ApplicationController
  def join
    @email = Email.new
  end

  def send_email
    email = Email.new(params.require(:email).permit(:email))
    if email.save
      redirect_to :root, notice: "Your email has been saved"
    else
      redirect_to :root, error: "Sorry, there has been a problem. Try again later."
    end
  end

  def home
    if Rails.env == "test"
      @statements, @individuals = [], []
      9.times do
        @statements << Statement.first
        @individuals << Individual.first
      end
    else
      @statements = [1, 3, 8, 5, 6, 7, 9, 13, 14].map{ |s| Statement.find(s) }
      @individuals = [5, 6, 1, 18, 17, 12, 19, 23, 24].map{ |i| Individual.find(i) }
    end
  end

  def contact
  end
end

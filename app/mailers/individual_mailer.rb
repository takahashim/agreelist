class IndividualMailer < ActionMailer::Base
  def password_reset(individual)
    @individual = individual
    @base_url = Rails.env.production? ? "http://www.agreelist.com" : "http://www.localhost:3000"
    mail(to: individual.email, from: "hector@agreelist.com", subject: "Password Reset - AgreeList")
  end
end

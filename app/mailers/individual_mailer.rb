class IndividualMailer < ActionMailer::Base
  def password_reset(individual)
    @individual = individual
    @base_url = Rails.env.production? ? "http://www.agreelist.com" : "http://www.localhost:3000"
    mail(to: individual.email, from: "feedback@agreelist.com", subject: "AgreeList - Password Reset")
  end

  def account_activation(individual)
    @individual = individual
    @base_url = Rails.env.production? ? "http://www.agreelist.com" : "http://www.localhost:3000"
    mail(to: individual.email, from: "feedback@agreelist.com", subject: "AgreeList - Account activation")
  end
end

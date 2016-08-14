class ContactMailer < ActionMailer::Base
  def contact(individual, args)
    @individual = individual
    @body = args[:body]
    @args = args
    mail(to: "hi@hectorperezarenas.com", from: "feedback@agreelist.com", subject: args[:subject])
  end
end

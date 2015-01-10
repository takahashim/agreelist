class LogMailer < ActionMailer::Base
  default from: "feedback@agreelist.com"

  def log_email(text)
    @text = text
    mail(to: "hi@hectorperezarenas.com", subject: text)
  end
end

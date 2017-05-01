class LogMailer < ActionMailer::Base
  def log_email(text)
    @text = text
    mail(to: "hecpeare@gmail.com", from: "hello@agreelist.org", subject: text)
  end
end

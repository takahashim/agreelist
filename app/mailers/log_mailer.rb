class LogMailer < ActionMailer::Base
  def log_email(text)
    @text = text
    mail(to: "hecpeare@gmail.com", from: "feedback@agreelist.com", subject: text)
  end
end

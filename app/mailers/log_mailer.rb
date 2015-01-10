class LogMailer < ActionMailer::Base
  default from: "feedback@agreelist.com"

  def log_email(text)
    @text = text
    mail(to: "hecpeare@gmail.com", subject: text)
  end
end

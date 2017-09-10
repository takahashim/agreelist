class LogMailer < ActionMailer::Base
  def log_email(text, params = {})
    @text = text
    @params = params
    mail(to: "hecpeare@gmail.com", from: "hello@agreelist.org", subject: text)
  end
end

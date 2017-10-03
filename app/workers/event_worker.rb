class EventWorker
  include Sidekiq::Worker

  def perform(args)
    event = args["event"]
    i = Individual.find(args["individual_id"])
    ip = args["ip"]
    LogMailer.log_email("event: #{event}, #{i.name} (@#{i.twitter}, #{i.email}), ip: #{ip}").deliver
  end
end

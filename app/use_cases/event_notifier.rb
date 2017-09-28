class EventNotifier
  attr_reader :args

  def initialize(args)
    @args = args
  end

  def notify
    EventJob.perform_async(args)
    # Resque.enqueue(EventJob, args)
  end
end

class EventNotifier
  attr_reader :args

  def initialize(args)
    @args = args
  end

  def notify
    Resque.enqueue(EventJob, args)
  end
end

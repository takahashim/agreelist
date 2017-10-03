class EventNotifier
  attr_reader :args

  def initialize(args)
    @args = args
  end

  def notify
    EventWorker.perform_async(args)
  end
end

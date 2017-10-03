require "rails_helper"

describe EventNotifier do
  it "should send an event to sidekiq" do
    notifier = EventNotifier.new(event: "login", individual_id: 1)
    expect(EventWorker).to receive(:perform_async).with(event: "login", individual_id: 1).once
    notifier.notify
  end
end

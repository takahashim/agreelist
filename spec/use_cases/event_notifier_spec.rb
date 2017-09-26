require "rails_helper"

describe Shortener do
  before do
    @statement = create(:statement)
  end

  it "should send an event to resque" do
    notifier = EventNotifier.new(event: "login", individual_id: 1)
    expect(Resque).to receive(:enqueue).with(EventJob, event: "login", individual_id: 1).once
    notifier.notify
  end
end

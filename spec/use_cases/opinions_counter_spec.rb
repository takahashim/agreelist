require "rails_helper"

describe OpinionsCounter do
  before do
    @statement = create(:statement)
  end

  it "should increase opinions_counter" do
    oc = OpinionsCounter.new(statement: @statement)
    expect{ oc.increase_by_one }.to change{ @statement.opinions_count }.by(1)
  end
end

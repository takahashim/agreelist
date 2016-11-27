require "rails_helper"

describe Voter do
  it "find user using wikipedia link" do
    VCR.use_cassette("use_cases/wikidata") do
      create(:individual, wikipedia: "http://en.wikipedia.com/Muhammad_Yunus")
    end
    voter = Voter.new(name: "Superman", current_user: create(:individual), wikipedia: "http://en.wikipedia.com/Muhammad_Yunus")
    expect{voter.find_or_create!}.not_to change{Individual.count}
  end
end
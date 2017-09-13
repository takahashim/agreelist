require "rails_helper"

describe TagsCache do
  before do
    @statement_1 = create(:statement)
    @individual_1 = create(:individual)
    @individual_1.occupation_list.add("journalist", "economist")
    @individual_1.save
    @individual_2 = create(:individual)
    @individual_2.occupation_list.add("journalist", "scientist")
    @individual_2.save
    create(:agreement, individual: @individual_1, statement: @statement_1)
    create(:agreement, individual: @individual_2, statement: @statement_1)

    @statement_2 = create(:statement)
    @individual_3 = create(:individual)
    @individual_3.occupation_list.add("journalist", "economist")
    @individual_3.save
    create(:agreement, individual: @individual_1, statement: @statement_2)
  end

  it "global tags cache" do
    expect(OccupationsCache.read).to eq [["journalist", "3"], ["economist", "2"], ["scientist", "1"]]
  end

  it "statement tags cache" do
    expect(OccupationsCache.new(statement: @statement_1).read).to eq [["journalist", "2"], ["economist", "1"], ["scientist", "1"]]
  end
end

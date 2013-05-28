require 'spec_helper'

describe Individual do
  let(:individual) { create(:individual) }

  subject { individual }

  it "should update tag_list" do
    list = "Batman, Superman"
    individual.tag_list = list
    expect(individual.tags.map(&:name).sort.join(", ")).to eq(list)
  end
end

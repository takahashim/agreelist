require 'spec_helper'

describe Statement do
  let(:statement) { create(:statement) }
  let(:individual) { create(:individual) }

  subject { statement }

  it { should respond_to(:individuals) }

  it "should destroy associated agreements" do
    statement.agreements.create(individual: individual, url: "http://...")
    agreements = statement.agreements.dup
    statement.destroy
    agreements.each do |a|
      Agreement.find_by_id(a.id).should be_nil
    end
  end

  describe "shouldn't be created when statement is too long" do
    before { statement.content = "h" * 501 }
    it { should_not be_valid }
  end

  it "returns agreements in favor" do
    a = create(:agreement, extent: 100, statement_id: statement.id)
    expect(statement.agreements_in_favor).to eq [a]
  end

  it "returns agreements against" do
    a = create(:agreement, extent: 0, statement_id: statement.id)
    expect(statement.agreements_against).to eq [a]
  end

  it "doesn't return agreements against" do
    a = create(:agreement, extent: 100, statement_id: statement.id)
    create(:agreement, extent: 0, statement_id: statement.id)
    expect(statement.agreements_in_favor).to eq [a]
  end

  context "#shortened_content" do
    it "should shorten the content" do
      s = create(:statement, content: "0123456789")
      expect(s.shortened_content(7)).to eq "0123..."
    end
  end
end

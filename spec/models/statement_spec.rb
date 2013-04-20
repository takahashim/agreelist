require 'spec_helper'

describe Statement do
  let(:statement) { FactoryGirl.create(:statement) }
  
  subject { statement }

  it { should respond_to(:individuals) }

  it "should destroy associated agreements" do
    statement.agreements.create(individual_id: 1, url: "http://...")
    agreements = statement.agreements.dup
    statement.destroy
    agreements.each do |a|
      Agreement.find_by_id(a.id).should be_nil
    end
  end

  describe "when statement is too long" do
    before { statement.content = "h" * 141 }
    it { should_not be_valid }
  end
end

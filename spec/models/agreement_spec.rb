require 'spec_helper'

describe Agreement do

  let(:statement) { FactoryGirl.create(:statement) }
  let(:individual) { FactoryGirl.create(:individual) }

  before do
    @agreement = statement.agreements.build(url: "http://example.com", individual_id: individual.id)
  end

  subject { @agreement }

  it { should respond_to(:url) }
  it { should respond_to(:statement_id) }
  it { should respond_to(:individual_id) }

  describe "when statement_id is not present" do
    before { @agreement.statement_id = nil }
    it { should_not be_valid }
  end
  describe "when individual_id is not present" do
    before { @agreement.individual_id = nil }
    it { should_not be_valid }
  end
end

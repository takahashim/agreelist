require 'spec_helper'

describe "Statement" do

  subject { page }

  describe "Index" do

    it "should have 'Listing statements'" do
      visit statements_path
      should have_selector('h1', text: 'Listing statements')
    end
  end

  describe "New" do
    
    it "link to New should be present" do
      visit statements_path
      should have_link("New Statement")
    end

    it "go to New and create" do
      visit statements_path
      click_link "New Statement"
      fill_in "Content", with: "Yeah"
      expect{ click_button "Create Statement" }.to change(Statement, :count).by(1)
    end
  end

  describe "Show" do
    #let(:statement) { create(:statement) }
    #let!(:individual) { create(:individual, name: "batman") } 
    statement = FactoryGirl.create(:statement)
 
    before { visit statement_path(statement) }
      
    describe "has content" do
      it { should have_content(statement.content) }
    end

    describe "has individuals" do
      individual = FactoryGirl.create(:individual)
      agreement = FactoryGirl.create(:agreement, individual_id: individual.id, statement_id: statement.id, extent: 100)

      it { should have_content(individual.name) }
      it { should have_content(statement.agreements_in_favor.size) }
      it { should have_content(statement.agreements_against.size) }
      it { should have_link(individual.name, href: individual_path(individual)) }
      it { should have_link("source", href: agreement.url) }
    end

    describe "with invalid info" do
      it "don't add an individual" do
        expect { click_button "Add" }.not_to change(Agreement, :count)
      end
    end

    describe "with valid info" do
      before do
        choose 'add_agreement'
        fill_in 'new_supporter', with: 'Superman'
        fill_in 'source', with: 'http://'
      end

      it "add an individual" do
        expect { click_button "Add" }.to change(Agreement, :count)
      end
    end
  end
end

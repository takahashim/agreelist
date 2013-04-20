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
    let(:statement) { FactoryGirl.create(:statement) }
    let!(:individual) { FactoryGirl.create(:individual, name: "batman") } 
    let!(:agreement) { FactoryGirl.create(:agreement, url: "http://example.com", individual_id: individual.id, statement_id: statement.id) } 
 
    before { visit statement_path(statement) }
      
    describe "has content" do
      it { should have_content(statement.content) }
    end

    describe "has individuals" do
      it { should have_content(individual.name) }
      it { should have_content(statement.individuals.count) }
      it { should have_link(individual.name, href: individual_path(individual)) }
      it { should have_link("source", href: agreement.url) }
    end
  end
end

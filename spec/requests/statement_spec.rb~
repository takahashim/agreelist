require 'spec_helper'

describe "Statement" do

  describe "Index" do

    it "should have 'Listing statements'" do
      visit statements_path
      page.should have_selector('h1', text: 'Listing statements')
    end
  end

  describe "New" do
    
    it "link to New should be present" do
      visit statements_path
      page.should have_link("New Statement")
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
    it "yeahhh" do
      visit statement_path(statement)
      page.should have_content(statement.content)
    end
  end
end

require 'spec_helper'

feature 'voting', js: true do
  before do
    s = Statement.create(content: "Is global warming real?")
    Agreement.create(individual: create(:individual), statement: s, extent: 100)
    visit "/auth/twitter"
    visit new_path
  end

  scenario "should find an opinion" do
    expect(page).to have_content("Is global warming real?")
  end
  
  scenario "test login" do
    visit "/auth/twitter"
    expect(page).to have_content("Sign Out")
  end

  context "clicking on agree" do
    scenario "should authenticate and vote" do
      first(".vote_link").click
      click_button "Save"
      expect(page).to have_content("Hector Perez")
    end
  end

  context "clicking on disagree" do
    scenario "should authenticate and vote" do
      all(".vote_link")[1].click
      click_button "Save"
      expect(page).to have_content("Hector Perez")
    end
  end

  context "create question" do
    scenario "should authenticate and create statement" do
      click_link "Create a topic or statement"
      fill_in :statement_content, with: "Does poverty fuel terrorism?"
      click_button "Create"
      expect(page).to have_content("Does poverty fuel terrorism?")
    end
  end
end

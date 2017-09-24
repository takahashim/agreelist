require 'spec_helper'

feature 'voting', js: true do
  attr_reader :statement

  before do
    seed_data
  end

  context 'logged user' do
    before do
      login
      visit statement_path(statement)
    end

    scenario "agree" do
      click_link "You?"
      click_link "I agree"
      fill_in :agreement_reason, with: "because..."
      click_button "Save"
      expect(page).to have_content("Hector Perez")
      expect(page).to have_content("Agree 100%")
      expect(page).to have_content("2 influencers")
    end

    scenario "disagree" do
      click_link "You?"
      click_link "I disagree"
      fill_in :agreement_reason, with: "because..."
      click_button "Save"
      expect(page).to have_content("Hector Perez")
      expect(page).to have_content("50% Disagree")
      expect(page).to have_content("2 influencers")
    end
  end

  context 'non logged user' do
    before do
      visit statement_path(statement)
    end

    scenario "agree" do
      click_link "You?"
      click_link "I agree"
      click_link "vote-twitter-login"
      fill_in :agreement_reason, with: "because..."
      click_button "Save"
      expect(page).to have_content("Hector Perez")
      expect(page).to have_content("Agree 100%")
      expect(page).to have_content("2 influencers")
    end

    scenario "disagree" do
      click_link "You?"
      click_link "I disagree"
      click_link "vote-twitter-login"
      fill_in :agreement_reason, with: "because..."
      click_button "Save"
      expect(page).to have_content("Hector Perez")
      expect(page).to have_content("Agree 50%")
      expect(page).to have_content("2 influencers")
    end
  end

  private

  def seed_data
    @statement = create(:statement)
    create(:agreement, statement: @statement, individual: create(:individual, twitter: "seed"), extent: 100, reason: "whatever")
    create(:reason_category, name: "Politics")
    create(:profession, name: "Politician")
  end

  def login
    visit "/auth/twitter"
  end
end


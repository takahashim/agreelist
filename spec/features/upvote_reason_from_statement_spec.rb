require 'spec_helper'

feature 'upvote', js: true do
  attr_reader :statement

  before do
    seed_data
  end

  context 'logged user' do
    before do
      visit statement_path(statement)
    end

    scenario "should change text to upvoted! (1)" do
      click_link "Agree"
      click_link "vote-twitter-login"
      click_button "Save"
      expect(page).not_to have_content("upvoted! (1)")
      expect{ click_upvote }.to change{ upvote.count }.by(1)
      expect(page).to have_content("upvoted! (1)")
    end

    scenario "should change upvotes_count" do
      click_link "Agree"
      click_link "vote-twitter-login"
      click_button "Save"
      before_counter = Agreement.last.upvotes_count
      click_upvote
      after_counter = Agreement.last.upvotes_count
      expect(after_counter).to eq before_counter + 1
    end

    context "when updating twice" do
      scenario "should destroy the upvote" do
        click_link "You?"
        click_link "I agree"
        click_link "vote-twitter-login"
        click_button "Save"
        click_upvote
        expect{ click_link "upvoted! (1)" }.to change{ upvote.count }.by(-1)
      end
    end
  end

  context 'non logged user' do
    before do
      visit statement_path(statement)
    end

    scenario "upvote" do
      click_link "upvote"
      click_link "upvote-twitter-login"
      expect(page).to have_content("upvoted! (1)")
    end
  end

  private

  def click_upvote
    first(:link, "upvote").click # click_link "upvote" seems to find two links, wtf?
  end

  def seed_data
    @statement = create(:statement)
    @agreement = create(:agreement, statement: @statement, individual: create(:individual), extent: 100)
  end
end

require 'spec_helper'

feature 'upvote', js: true do
  attr_reader :statement

  before do
    seed_data
  end

  context 'non logged user' do
    before do
      visit statement_path(statement)
    end

    scenario "should change text to Upvoted! (1)" do
      click_link "Agree"
      click_link "vote-twitter-login"
      click_button "Save"
      expect(page).not_to have_content("Upvoted! (1)")
      expect{ click_link "Upvote" }.to change{ Upvote.count }.by(1)
      expect(page).to have_content("Upvoted! (1)")
    end

    scenario "should change upvotes_count" do
      click_link "Agree"
      click_link "vote-twitter-login"
      click_button "Save"
      before_counter = Agreement.last.upvotes_count
      click_link "Upvote"
      after_counter = Agreement.last.upvotes_count
      expect(after_counter).to eq before_counter + 1
    end

    context "when updating twice" do
      scenario "should destroy the upvote" do
        click_link "Agree"
        click_link "vote-twitter-login"
        click_button "Save"
        click_link "Upvote"
        expect{ click_link "Upvoted! (1)" }.to change{ Upvote.count }.by(-1)
      end
    end
  end

  private

  def seed_data
    @statement = create(:statement)
  end
end

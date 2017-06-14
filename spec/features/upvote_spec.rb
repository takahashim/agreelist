require 'spec_helper'

feature 'upvote', js: true do
  attr_reader :statement

  before do
    seed_data
  end

  2.times do |index|
    context 'logged user' do
      before do
        visit "/auth/twitter"
        visit [statement_path(@statement), root_path][index]
      end

      scenario "should change text to upvoted! (1)" do
        expect(page).not_to have_content("upvoted! (1)")
        expect{ click_upvote }.to change{ Upvote.count }.by(1)
        expect(page).to have_content("upvoted! (1)")
      end

      scenario "should change upvotes_count" do
        before_counter = Agreement.last.upvotes_count
        click_upvote
        after_counter = Agreement.last.upvotes_count
        expect(after_counter).to eq before_counter + 1
      end

      context "when updating twice" do
        scenario "should destroy the upvote" do
          click_upvote
          expect{ click_link "upvoted! (1)" }.to change{ Upvote.count }.by(-1)
        end
      end
    end

    context 'non logged user' do
      before do
        visit [statement_path(@statement), root_path][index]
      end

      context 'sign in with twitter' do
        scenario "upvote" do
          click_link "upvote"
          click_link "upvote-twitter-login"
          expect(page).to have_content("upvoted! (1)")
        end
      end

      context 'sign in with email' do
        scenario "upvote" do
          click_link "upvote"
          click_link "upvote-email-login"
          click_link "Sign up!"
          fill_in :individual_email, with: "whatever@email.com"
          fill_in :individual_password, with: "whatever-password"
          fill_in :individual_password_confirmation, with: "whatever-password"
          click_button "Sign up"
          expect(page).to have_content("Upvoted!")
        end
      end
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

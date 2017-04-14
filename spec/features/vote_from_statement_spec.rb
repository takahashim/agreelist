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

    scenario 'adds reason category' do
      fill_in 'name', with: "Cesar Perez"
      select "Politics", from: "reason_category_id"
      click_button "She/he agrees"
      expect(Agreement.last.reason_category.name).to eq "Politics"
    end

    scenario 'adds profession' do
      fill_in 'name', with: "Cesar Perez"
      select "Politician", from: "profession_id"
      click_button "She/he agrees"
      expect(Agreement.last.individual.profession.name).to eq "Politician"
    end


    scenario 'should open share on twitter modal window' do
      fill_in 'name', with: "@barackobama"
      click_button "She/he agrees"
      expect(page).to have_content "Wanna tweet you added @barackobama?"
    end

    scenario "agree" do
      click_link "You?"
      click_link "I agree"
      click_button "Save"
      expect(page).to have_content("Hector Perez")
      expect(page).to have_content("Agree 100%")
      expect(page).to have_content("2 influencers")
    end

    scenario "disagree" do
      click_link "You?"
      click_link "I disagree"
      click_button "Save"
      expect(page).to have_content("Hector Perez")
      expect(page).to have_content("50% Disagree")
      expect(page).to have_content("2 influencers")
    end

    scenario 'adds someone who disagrees' do
      fill_in 'name', with: 'Hector Perez'

      click_button "She/he disagree"
      expect(Agreement.last.disagree?).to eq(true)
    end

    scenario 'adds someone who disagrees with its twitter' do
      fill_in 'name', with: "@arpahector"
      click_button "She/he disagree"
      expect(Individual.last.twitter).to eq "arpahector"
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
      click_button "Save"
      expect(page).to have_content("Hector Perez")
      expect(page).to have_content("Agree 100%")
      expect(page).to have_content("2 influencers")
    end

    scenario "disagree" do
      click_link "You?"
      click_link "I disagree"
      click_link "vote-twitter-login"
      click_button "Save"
      expect(page).to have_content("Hector Perez")
      expect(page).to have_content("Agree 50%")
      expect(page).to have_content("2 influencers")
    end

    scenario 'adds someone who disagrees' do
      fill_in 'name', with: 'Hector Perez'

      click_button "She/he disagree"
      expect(Agreement.last.disagree?).to eq(true)
    end

    scenario 'comment' do
      fill_in 'name', with: 'Hector Perez'
      fill_in 'comment', with: 'Because...'

      click_button "She/he disagree"
      expect(Agreement.last.reason).to eq "Because..."
    end

    scenario 'bio' do
      fill_in 'name', with: "Hector Perez"
      fill_in 'biography', with: "Hero"
      click_button "She/he agrees"
      expect(page).to have_text('Hero')
    end

    scenario 'should create two users when adding someone else' do
      fill_in 'name', with: 'Hector Perez'
      fill_in 'source', with: 'http://...'
      fill_in 'email', with: 'hhh@jjj.com'

      expect{ click_button "She/he agrees" }.to change{ Individual.count }.by(2)
    end

    scenario 'adds someone who disagrees with its twitter' do
      fill_in 'name', with: "@arpahector"
      click_button "She/he disagree"
      expect(Individual.last.twitter).to eq "arpahector"
    end

    scenario 'adds two times the same @user' do
      fill_in 'name', with: "@arpahector"
      click_button "She/he agrees"
      click_link 'Back'
      fill_in 'name', with: "@arpahector"
      click_button "She/he agrees"
      expect(Individual.all.order(:twitter).map(&:twitter)).to eq %w(arpahector seed)
    end

  end

  private

  def seed_data
    @statement = create(:statement)
    create(:agreement, statement: @statement, individual: create(:individual, twitter: "seed"), extent: 100)
    create(:reason_category, name: "Politics")
    create(:profession, name: "Politician")
  end

  def login
    visit "/auth/twitter"
  end
end


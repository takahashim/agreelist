require 'spec_helper'

feature "professions", js: true do
  attr_reader :statement

  before do
    seed_data
  end

  context "non logged user" do
    before do
      visit statement_path(statement)
    end

    scenario "should set a profession" do
      click_link "You?"
      click_link "I agree"
      click_link "vote-twitter-login"
      Agreement.last.update_attributes(reason: "blablabla")
      visit statement_path(statement)
      expect(Agreement.last.present?).to eq true
      select "Politician", from: "profession_from_agreement_#{Agreement.last.id}"
      expect(Agreement.last.individual.profession.name).to eq "Politician"
    end
  end

  scenario "should filter per profession" do
    visit statement_path(statement)
    expect(page).to have_content("Opinions from 2 influencers")
    click_link "Politicians"
    expect(page).to have_content("Opinions from 1 influencer")
  end

  def seed_data
    @statement = create(:statement)
    politician = Profession.create(name: "Politician")
    Profession.create(name: "Scientist")
    create(:agreement, statement: @statement, individual: create(:individual, profession: politician), extent: 100)
    create(:agreement, statement: @statement, individual: create(:individual), extent: 100)
  end

  def login
    visit "/auth/twitter"
  end
end

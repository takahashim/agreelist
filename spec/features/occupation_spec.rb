require 'spec_helper'

feature "occupations", js: true do
  attr_reader :statement

  scenario "should filter per occupation" do
    seed_data
    visit brexit_board_path
    click_link "Politicians"
    expect(page).to have_content("Opinions from 1 politician")
  end

  def seed_data
    @statement = create(:statement)
    individual = create(:individual)
    individual.occupation_list = ["politician", "economist"]
    individual.save
    create(:agreement, statement: @statement, individual: individual, extent: 100)
    create(:agreement, statement: @statement, individual: create(:individual), extent: 100)
  end

  def login
    visit "/auth/twitter"
  end
end

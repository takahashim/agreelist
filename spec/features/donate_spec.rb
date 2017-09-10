require 'spec_helper'

feature 'statement' do
  attr_reader :statement

  before do
    seed_data
  end

  scenario "button donate should go and fill form" do
    visit statement_path(@statement)
    click_link "add more?"
    click_link "donate $100 and we'll find 50 influencers"
    expect(page).to have_content("I'd like to donate $100 so you can help me to find 50 influencers for the topic or statement: #{@statement.content}")
  end

  def seed_data
    @statement = create(:statement)
    @profession = create(:profession, name: "Economist")
  end
end

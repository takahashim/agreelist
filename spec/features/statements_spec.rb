require 'spec_helper'

feature 'statement', js: true do
  attr_reader :statement

  before do
    seed_data
  end

  scenario "filter per profession" do
    create(:agreement, statement: @statement, individual: create(:individual), extent: 100)
    create(:agreement, statement: @statement, individual: create(:individual, profession: @profession), extent: 100)
    visit statement_path(@statement) + "?profession=#{@profession.name}"
    expect(page).to have_content("100% of 1 opinion")
  end

  scenario "new issue or statement" do
    visit "/auth/twitter"
    click_link "Create a topic or statement"
    fill_in :statement_content, with: "We should do more to tacle global warming"
    click_button "Create"
    expect(page).to have_content("Statement was successfully created")
  end

  scenario "button pay should go and fill form" do
    visit statement_path(@statement)
    click_link "Pay $100 and we'll find 50 influencers*"
    expect(page).to have_selector("input[value='Help me to find influencers']")
    expect(page).to have_content("I'd like to pay $100 so you can help me to find 50 influencers for the topic or statement: #{@statement.content}")
  end

  def seed_data
    @statement = create(:statement)
    @profession = create(:profession, name: "Economist")
  end
end

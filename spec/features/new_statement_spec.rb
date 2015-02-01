require 'spec_helper'

feature 'statement' do
  before do
    login
    visit "/statement"
  end

  scenario 'new' do
    fill_in 'content', with: 'Is global warming real?'

    click_button "Next"
    expect(Statement.last.content).to eq("Is global warming real?")
  end

  def login
    Individual.create(name: "Hector", twitter: "arpahector")
    visit "/auth/twitter"
  end
end

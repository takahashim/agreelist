require 'spec_helper'

feature 'entrepreneurs' do
  attr_reader :statement

  before do
    seed_data
  end

  scenario "should load page" do
    visit "/entrepreneurs"
    expect(page).to have_content("Advice for entrepreneurs")
  end

  def seed_data
    create(:statement)
    create(:individual)
  end
end

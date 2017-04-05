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
    @statement = create(:statement)
    @profession = create(:profession, name: "Economist")
    create(:agreement, statement: @statement, individual: create(:individual), extent: 100)
    create(:agreement, statement: @statement, individual: create(:individual, profession: @profession), extent: 100)
  end
end

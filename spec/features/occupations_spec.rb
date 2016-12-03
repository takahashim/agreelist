require 'spec_helper'

feature 'schools#show' do
  before do
    create(:individual, name: "Elon Musk", twitter: "elonmusk", occupation_list: "A, B, C")
  end

  scenario "user profile should link to occupations" do
    visit "/elonmusk"
    click_link "A"
    expect(page).to have_link "Elon Musk"
  end
end
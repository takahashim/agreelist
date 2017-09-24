require 'spec_helper'

feature "search", js: true do
  scenario "should find a statement" do
    statement = create(:statement, content: "Universal Basic Income")
    create(:agreement, statement: statement, reason: "blabla")
    visit new_search_path
    fill_in :search, with: "Basic Income"
    click_button "Search"
    expect(page).to have_content("Universal Basic Income (1 opinion)")
  end

  scenario "should find a person" do
    Individual.create(name: "Bill Gates")
    visit new_search_path
    fill_in :search, with: "Bill"
    click_button "Search"
    expect(page).to have_content("Bill Gates")
  end

  scenario "should find an opinion" do
    create(:agreement, reason: "It will help society")
    visit new_search_path
    fill_in :search, with: "Society"
    click_button "Search"
    expect(page).to have_content("It will help society")
  end
end

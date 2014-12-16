require 'spec_helper'

feature "title" do
  scenario "should have h1" do
    visit "/"
    expect(page).to have_selector('h1', text: 'Liquid Democracy')
  end
end

feature "contact email" do
  scenario "should have contact email" do
    visit "/"
    click_on "Contact"
    expect(page).to have_text("feedback@agreelist.com")
  end
end

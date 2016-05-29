require 'spec_helper'

feature 'signup' do
  before do
    create(:individual, email: "my@email.com", is_user: true, password: "password", password_confirmation: "password")
    seed_data
  end

  scenario 'should log in' do
    visit '/login'
    fill_in :email, with: "my@email.com"
    fill_in :password, with: "password"
    click_button "Log in"
    expect(page).to have_content("Sign Out")
  end

  def seed_data
    create(:agreement, statement: create(:statement), individual: create(:individual), extent: 100)
  end
end

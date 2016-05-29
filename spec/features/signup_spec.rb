require 'spec_helper'

feature 'signup' do
  before do
    create(:agreement, statement: create(:statement), individual: create(:individual), extent: 100)
  end

  scenario "should signup" do
    visit '/signup'
    fill_in :individual_email, with: 'my@email.com'
    fill_in :individual_password, with: 'password'
    fill_in :individual_password_confirmation, with: 'password'
    click_button "Sign up"
    expect(page).to have_content("Sign Out")

    expect(ActionMailer::Base.deliveries.last).not_to be nil
    activation_link = ActionMailer::Base.deliveries.last.body.raw_source.scan(/http.*activation/).first
    visit activation_link
    expect(page).to have_content("Your account has been activated")
  end

  scenario "should NOT signup if password confirmation doesnt match" do
    visit '/signup'
    fill_in :individual_email, with: 'my@email.com'
    fill_in :individual_password, with: 'password'
    fill_in :individual_password_confirmation, with: 'password2'
    click_button "Sign up"
    expect(page).to have_content("Password confirmation doesn't match")
  end

  scenario "should NOT signup if email doesnt have a proper format" do
    visit '/signup'
    fill_in :individual_email, with: 'whatever.com'
    fill_in :individual_password, with: 'password'
    fill_in :individual_password_confirmation, with: 'password'
    click_button "Sign up"
    expect(page).to have_content("Email is invalid")
  end
end

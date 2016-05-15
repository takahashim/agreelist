require 'spec_helper'

feature 'forgot' do
  before do
    create(:individual, email: "my@email.com", is_user: true, password: "pass", password_confirmation: "pass")
    seed_data
  end

  scenario 'should send an email and change the password' do
    visit '/login'
    click_link "Forgot?"
    fill_in :forgot_email, with: "my@email.com"
    click_button "Reset password"
    expect(page).to have_content("Email sent with instructions to reset your password")
    expect(ActionMailer::Base.deliveries.last).not_to be nil

    reset_link = ActionMailer::Base.deliveries.last.body.raw_source.scan(/http.*edit/).first
    visit reset_link
    fill_in :reset_password_password, with: "new_password"
    fill_in :reset_password_password_confirmation, with: "new_password"
    click_button "Save password"
    expect(page).to have_content("Your password has been changed")
  end

  def seed_data
    create(:agreement, statement: create(:statement), individual: create(:individual, is_user: false), extent: 100)
  end
end

require 'spec_helper'

feature 'join' do
  before do
    login
  end

  scenario 'save email' do
    fill_in 'individual_email', with: 'myemail@example.com'
    click_button "Next"
    expect(@user.reload.email).to eq("myemail@example.com")
  end

  scenario 'redirect_to statement' do
    fill_in 'individual_email', with: 'myemail@example.com'
    click_button "Next"
    expect(current_path).to eq("/statement")
  end

  def login
    @user = Individual.create(name: "Hector", twitter: "arpahector")
    visit "/auth/twitter"
  end
end

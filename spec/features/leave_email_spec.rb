require 'spec_helper'

feature 'join' do
  before do
    Statement.create(content: "aaa")
    Individual.create(name: "bbbb")
  end

  scenario 'leave_email' do
    visit "/join"
    fill_in "email_email", with: "hi@hectorperezarenas.com"
    expect{click_on "Send"}.to change(Email, :count)
  end
end

require 'spec_helper'

feature 'disagree' do
  before do
    statement = Statement.create(content: "aaa")
    visit "/statements/#{statement.id}"
    http_login
  end

  scenario 'adds someone who disagrees' do
    choose 'add_disagreement'
    fill_in 'new_supporter', with: 'Superman'
    fill_in 'source', with: 'http://'

    click_button "Add"
    expect(Agreement.last.disagree?).to eq(true)
  end

  def http_login
    page.driver.browser.basic_authorize("hector", "perez")
  end
end

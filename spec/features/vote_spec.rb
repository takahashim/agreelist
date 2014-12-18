require 'spec_helper'

feature 'disagree' do
  before do
    statement = Statement.create(content: "aaa")
    expect(statement.valid?).to eq true
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
    name = 'hector'
    password = 'perez'
    # request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user,pw)

    if page.driver.respond_to?(:basic_auth)
      page.driver.basic_auth(name, password)
    elsif page.driver.respond_to?(:basic_authorize)
      page.driver.basic_authorize(name, password)
    elsif page.driver.respond_to?(:browser) && page.driver.browser.respond_to?(:basic_authorize)
      page.driver.browser.basic_authorize(name, password)
    else
      raise "I don't know how to log in!"
    end
  end
end

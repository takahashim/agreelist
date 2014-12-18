require 'spec_helper'

feature 'disagree' do
  before do
    statement = Statement.create(content: "aaa")
    expect(statement.valid?).to eq true
    visit "/statements/#{statement.id}"
  end

  scenario 'adds someone who disagrees' do
    choose 'add_disagreement'
    fill_in 'new_supporter', with: 'Superman'
    fill_in 'source', with: 'http://'

    click_button "Add"
    expect(Agreement.last.disagree?).to eq(true)
  end
end

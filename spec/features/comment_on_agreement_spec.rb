require 'spec_helper'

feature 'comment', js: true do
  before do
  	seed_data
  	authenticate_as(@individual2)
  	visit statement_path(@statement)
  	click_link @individual.name
  end

  scenario "new" do
  	fill_in :agreement_comment_content, with: "bla bla"
    click_button "Send"
    expect(page).to have_content("bla bla")
    expect(page).to have_content(@individual2.name)
  end


  private

  def seed_data
    @statement = create(:statement)
    @individual = create(:individual)
    @individual2 = create(:individual)
    create(:agreement, individual: @individual, statement: @statement, extent: 100)
  end

  def authenticate_as(user)
    page.set_rack_session(user_id: user.id)
  end
end
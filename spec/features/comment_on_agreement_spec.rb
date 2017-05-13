require 'spec_helper'

feature 'comment', js: true do
  before do
  	seed_data
    visit "/auth/twitter"
  	visit statement_path(@statement)
    click_link "comment"
  end

  scenario "new" do
  	fill_in :agreement_comment_content, with: "bla bla"
    click_button "Send"
    expect(page).to have_content("bla bla")
    expect(page).to have_content('Hector Perez')
  end


  private

  def seed_data
    @statement = create(:statement)
    @individual = create(:individual)
    @individual2 = create(:individual)
    create(:agreement, individual: @individual, statement: @statement, extent: 100)
  end
end

require 'spec_helper'

feature 'statements' do
  attr_reader :statement

  before do
    seed_data
  end

  context "non logged user" do
    scenario "should list opinions" do
      visit statements_path
      expect(page).to have_content("#{@statement.content} · 2 opinions")
    end

    scenario "should allow to destroy a statement" do
      visit statements_path
      expect(page).not_to have_link("Destroy")
    end
  end

  context "logged in as hector" do
    scenario "should allow to destroy statement" do
      visit "/auth/twitter"
      visit statements_path
      click_link "Destroy"
      expect(page).not_to have_content("#{@statement.content} · 2 opinions")
    end
  end

  def seed_data
    @statement = create(:statement)
    @profession = create(:profession, name: "Economist")
    create(:agreement, statement: @statement, individual: create(:individual), extent: 100)
    create(:agreement, statement: @statement, individual: create(:individual, profession: @profession), extent: 100)
  end
end

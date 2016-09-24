require "spec_helper"

feature "tags" do
  before do
    seed_data
  end

  scenario "should find two economists" do
    visit statement_path(@statement)
    click_on "Table"
    expect(page).to have_content("economist 2 politician 1 journalist 1")
  end

  private

  def seed_data
    @statement = create(:statement)
    add_person(occupations: %w(economist politician))
    add_person(occupations: %w(journalist economist))
  end

  def add_person(args)
    individual = create(:individual)
    Agreement.create(statement: @statement, individual: individual, extent: 100)
    individual.occupation_list = args[:occupations]
    individual.save
  end
end

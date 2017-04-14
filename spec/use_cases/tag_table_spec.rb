require "rails_helper"

describe OccupationsTable do
  it "should return the table" do
    seed_data
    object = OccupationsTable.new(statement: @statement)
    object.stub(:min_count).and_return(1)
    expect(object.table).to eq [
      {name: "economist", count: 2, percentage_who_agrees: 50},
      {name: "politician", count: 1, percentage_who_agrees: 100},
      {name: "journalist", count: 1, percentage_who_agrees: 0}
    ]
  end

  private

  def seed_data
    @statement = create(:statement)
    add_person(occupations: %w(economist politician), extent: 100)
    add_person(occupations: %w(journalist economist), extent: 0)
  end

  def add_person(args)
    individual = create(:individual)
    Agreement.create(statement: @statement, individual: individual, extent: args[:extent] || 100)
    individual.occupation_list = args[:occupations]
    individual.save
  end
end

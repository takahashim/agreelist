require "rails_helper"

describe TagTable do
  it "should" do
    table = TagTable.new(statement: @statement)
    expect(table.map(&:percentage_who_agrees)).to eq [100] 
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

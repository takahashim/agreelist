class OccupationsCache
  attr_reader :statement
  MIN_COUNT = 1

  def initialize(args)
    @statement = args[:statement]
  end

  def update
    statement.update_attribute(:occupations_cache, occupations)
  end

  def self.update_all
    Statement.all.each do |statement|
      new(statement: statement).update
    end
  end

  private

  def occupations
    OccupationsTable.new(statement: statement, min_count: MIN_COUNT).table
  end
end

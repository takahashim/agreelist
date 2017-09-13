class OccupationsCache < TagsCache
  def tags
    if statement
      @occupations ||= OccupationsTable.new(statement: statement, min_count: MIN_COUNT).table
    else
      self.class.tags
    end
  end

  def self.tags
    @occupations ||= AllOccupationsTable.new(min_count: MIN_COUNT).table
  end

  def self.tag_name
    "occupations"
  end
end

class OccupationsCache < TagsCache
  def tags
    @occupations ||= OccupationsTable.new(statement: statement, min_count: MIN_COUNT).table
  end

  def self.tag_name
    "occupations"
  end
end

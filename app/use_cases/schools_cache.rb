class SchoolsCache < TagsCache
  def tags
    if statement
      @tags ||= SchoolsTable.new(statement: statement, min_count: MIN_COUNT).table
    else
      self.class.tags
    end
  end

  def self.tags
    @tags ||= AllSchoolsTable.new(min_count: MIN_COUNT).table
  end

  def self.tag_name
    "schools"
  end
end

class SchoolsCache < TagsCache
  def tags
    @tags ||= SchoolsTable.new(statement: statement, min_count: MIN_COUNT).table
  end

  def tag_name
    "schools"
  end
end

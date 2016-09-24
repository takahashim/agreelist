class TagTable
  attr_reader :statement, :min_count

  def initialize(args)
    @statement = args[:statement]
    @min_count = args[:min_count] || 10
  end

  def table
    @occupations = []
    occupations_count.each{|occupation| count_occupation(occupation)}
    @occupations.sort_by{|o| -o[:percentage_who_agrees]}
  end

  private

  def count_occupation(occupation)
    ids = Individual.tagged_with(occupation, on: tag)
    all = Agreement.where(statement: statement, individual_id: ids).size
    agree = Agreement.where(statement: statement, individual_id: ids, extent: 100).size
    percentage = agree * 100 / all
    @occupations << {name: occupation.name, count: occupation.taggings_count, percentage_who_agrees: percentage}
  end

  def occupations_count
    statement.individuals.tag_counts_on(tag).where("taggings_count >= ?", min_count)
  end

  def tag
    raise NotImplementedError, 'This is an abstract base method. Implement in your subclass.'
  end
end
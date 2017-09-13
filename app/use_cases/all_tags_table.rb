class AllTagsTable
  attr_reader :min_count

  def initialize(args = {})
    @min_count = args[:min_count] || 50
  end

  def table
    @occupations = []
    occupations_count.each{|occupation| count_occupation(occupation)}
    @occupations.sort_by{|o| [-o[:count]]}
  end

  private

  def count_occupation(occupation)
    ids = Individual.where("opinions_count > 0").tagged_with(occupation.name, on: tag).pluck(:id)
    all = Agreement.where(individual_id: ids).where("reason is not null and reason != ''").size
    @occupations << {name: occupation.name, count: all}
  end

  def occupations_count
    Individual.where("opinions_count > 0").tag_counts_on(tag).where("taggings_count >= ?", min_count)
  end

  def tag
    raise NotImplementedError, 'This is an abstract base method. Implement in your subclass.'
  end
end

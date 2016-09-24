class TagTable
  attr_reader :statement, :min_count

  def initialize(args)
    @statement = args[:statement]
    @min_count = args[:min_count] || 50
  end

  def table
    @occupations = []
    occupations_count.each{|occupation| count_occupation(occupation)}
    @occupations.sort_by{|o| [-o[:percentage_who_agrees], -o[:count]]}
  end

  private

  def count_occupation(occupation)
    ids = Individual.tagged_with(occupation.name, on: tag)
    all = Agreement.where(statement_id: statement.id, individual_id: ids).size
    agree = Agreement.where(statement_id: statement.id, individual_id: ids, extent: 100).size
    percentage = agree * 100 / all
    @occupations << {name: occupation.name, count: all, percentage_who_agrees: percentage} if all >= min_count
  end

  def occupations_count
    statement.individuals.tag_counts_on(tag).where("taggings_count >= ?", min_count)
  end

  def tag
    raise NotImplementedError, 'This is an abstract base method. Implement in your subclass.'
  end

  def occupations_count2
    Tag.find_by_sql("
      SELECT tags.*, taggings.tags_count AS count
      FROM tags
      JOIN (SELECT taggings.tag_id, COUNT(taggings.tag_id) AS tags_count
        FROM taggings
        INNER JOIN individuals ON individuals.id = taggings.taggable_id
        WHERE (taggings.taggable_type = 'Individual' AND
               taggings.context = '#{tag.to_s}') AND
               (taggings.taggable_id IN (
                    SELECT individuals.id FROM individuals
                    INNER JOIN agreements ON individuals.id = agreements.individual_id
                    WHERE agreements.statement_id = #{statement.id}))
      GROUP BY taggings.tag_id HAVING COUNT(taggings.tag_id) > 0) AS taggings ON taggings.tag_id = tags.id
      WHERE (taggings_count >= #{min_count})")
  end
end
class OpinionsCounter
  attr_reader :statement

  def initialize(args)
    @statement = args[:statement]
  end

  def increase_by_one
    statement.update_attribute(:opinions_count, statement.opinions_count + 1)
  end

  def decrease_by_one
    statement.update_attribute(:opinions_count, statement.opinions_count - 1)
  end
end

class TagsCache
  attr_reader :statement
  MIN_COUNT = 1

  def initialize(args)
    @statement = args[:statement]
  end

  def read
    Rails.cache.fetch("tag:#{self.class.tag_name}") do
      tags
    end
  end

  # def update
  #   $redis.sadd(key, tags)
  #   tags
  # end

  def self.update_all
    Statement.all.each do |statement|
      Rails.logger.debug("updating #{tag_name} cache for statement #{statement.id}")
      new(statement: statement).update
    end
  end

  private

  def tags
    # define in child class
  end

  def self.tag_name
    # define in child class
  end

  def key
    "cache:#{self.class.tag_name}:#{statement.id}"
  end
end

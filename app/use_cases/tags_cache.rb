class TagsCache
  attr_reader :statement
  MIN_COUNT = 1

  def initialize(args)
    @statement = args[:statement]
  end

  def read
    read_from_redis_or_update.sort_by{|k,v| -v.to_i}
  end

  def update
    t = tags.map{|j| [j[:name], j[:count]]}.flatten
    $redis.hmset(key, *t) if t.any?
  end

  def add(tag_list, incr = 1)
    tag_list.each do |tag_name|
      $redis.hincrby(key, tag_name, incr)
    end
  end

  def self.update_all
    Statement.all.each do |statement|
      Rails.logger.debug("updating #{tag_name} cache for statement #{statement.id}")
      new(statement: statement).read
    end
  end

  private

  def read_from_redis_or_update
    result = $redis.hgetall(key)
    if result.empty?
      update
      $redis.hgetall(key)
    else
      result
    end
  end

  def tags
    # define in child class
  end

  def self.tag_name
    # define in child class
  end

  def key
    "cache:topic:#{statement.id}:#{self.class.tag_name}"
  end
end

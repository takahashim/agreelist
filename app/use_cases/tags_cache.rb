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
    self.class.instance_or_class_update(tags, key)
  end

  def self.update
    instance_or_class_update(tags, key)
  end

  def add(tag_list, incr = 1)
    tag_list.each do |tag_name|
      $redis.hincrby(key, tag_name, incr)
      $redis.hincrby(self.class.key, tag_name, incr)
    end
  end

  def self.update_all
    Statement.all.each do |statement|
      Rails.logger.debug("updating #{tag_name} cache for statement #{statement.id}")
      new(statement: statement).update
    end
    update
  end

  private

  def self.instance_or_class_update(tag_list, my_key)
    t = tag_list.map{|j| [j[:name], j[:count]]}.flatten
    $redis.hmset(my_key, *t) if t.any?
  end

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
    raise NotImplementedError, 'This is an abstract base method. Implement in your subclass.'
  end

  def self.tag_name
    raise NotImplementedError, 'This is an abstract base method. Implement in your subclass.'
  end

  def key
    if statement
      "cache:topic:#{statement.id}:#{self.class.tag_name}"
    else
      self.class.key
    end
  end

  def self.key
    "cache:all:#{tag_name}"
  end
end

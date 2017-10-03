unless Rails.env.test? # in test environment, $redis is set in the spec helper
  url = ENV['REDIS_URL'] || "redis://localhost:6379/"
  $redis = Redis.new(url: url)
end

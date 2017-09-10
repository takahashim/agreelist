class OpinionsCount < Thor
  desc "reload",
       "populate opinions_count for statements"
  def reload
    require './config/environment'
    Statement.find_each do |statement|
      puts "statement.id: #{statement.id}"
      count = statement.agreements.where("reason is not null and reason != ''").size
      puts statement.update_columns(opinions_count: count)
    end
  end
end

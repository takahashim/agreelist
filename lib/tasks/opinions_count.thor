class OpinionsCount < Thor
  desc "reload",
       "populate opinions_count for agreements"
  def reload
    require './config/environment'
    Agreement.find_each do |agreement|
      puts "agreement.id: #{agreement.id}"
      count = agreement.statement.agreements.where("reason is not null and reason != ''").size
      puts agreement.update_attribute(:opinions_count, count)
    end
  end
end

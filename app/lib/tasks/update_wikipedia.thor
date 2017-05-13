class UpdateWikipedia < Thor
  desc "all",
       "set wikipedia urls"

  def all
    require './config/environment'
    require 'wikipedia'

    Individual.where("wikipedia is null or wikipedia = ''").find_each do |individual|
      page = Wikipedia.find(individual.name)
      if page && page.content && page.content.scan(/There were no results matching the query|may refer to/).empty?
        puts "YES - #{individual.name} - #{page.fullurl}"
        individual.wikipedia = page.fullurl
        individual.save
      else
        puts "NO - #{individual.name}"
      end
    end
  end
end




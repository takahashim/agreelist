class Fetch < Thor
  desc "occupations_and_educated_at",
       "fetch occupations and educated_at from wikidata"

  def occupations_and_educated_at
    require './config/environment'
  	Individual.where("wikidata_id is not null").each do |individual|
      if individual.occupations.empty? && individual.schools.empty?
        puts "-----------------"
        puts individual.name
        individual.occupation_list = WikidataPerson.new(wikidata_id: individual.wikidata_id).occupations
        puts "occupations: #{individual.occupation_list}"
        individual.school_list = WikidataPerson.new(wikidata_id: individual.wikidata_id).educated_at
        puts "educated_at: #{individual.school_list}"
        puts individual.save
      else
        puts "skipping #{individual.name}"
      end
  	end
  end
end
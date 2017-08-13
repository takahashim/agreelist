class BioLink < Thor
  desc "extract",
       "move bio links in wikipedia field to its own field"
  def extract
    require './config/environment'
    Individual.where("wikipedia is not null and wikipedia != '' and wikipedia not ilike '%wikipedia.org%'").each do |i|
      puts i.wikipedia
      i.bio_link = i.wikipedia
      i.wikipedia = nil
      i.save!
    end
  end
end

class Export < Thor
  desc "brexit",
       "Export brexit data"

  def brexit
    require './config/environment'
    require "csv"
    CSV.open("agreements.csv", "wb") do |csv|
      puts "Exporting agreements"
      Agreement.select(:id, :statement_id, :individual_id, :reason, :extent).find_each do |a|
        csv << [a.id, a.statement_id, a.individual_id, a.reason, a.extent]
        puts a.id
      end
    end

    CSV.open("individuals.csv", "wb") do |csv|
      puts "Exporting individuals"
      Individual.select(:id, :wikidata_id, :name, :twitter, :bio, :followers_count).find_each do |i|
        csv << [i.id, i.wikidata_id, i.name, i.twitter, i.bio, i.followers_count]
        puts i.id
      end
    end

    CSV.open("statements.csv", "wb") do |csv|
      puts "Exporting statements"
      Statement.select(:id, :content).find_each do |s|
        csv << [s.id, s.content]
        puts s.id
      end
    end
  end
end
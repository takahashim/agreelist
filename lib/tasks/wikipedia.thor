class Wikipedia < Thor
  desc "update_wikidata_id_from_wikipedia",
       "update wikidata_id from wikipedia url"

  def update_wikidata_ids_from_wikipedia_urls
    require './config/environment'
    Individual.where("wikipedia is not null and wikipedia != '' and wikidata_id is null").find_each do |i|
      i.update_wikidata_id_and_twitter
      i.save
      puts "#{i.id}; #{i.name}"
    end
  end

  desc "import",
       "import from wikipedia"

  def import_data
    require './config/environment'
    #require 'net/http'
	  # IO.foreach("../wp-brexit-supporters.txt") do |line|
    refs = {}
    count = 0
    statement = Statement.find_by_hashed_id("sblrlc9vgxp7")
    uri = URI('https://s3-eu-west-1.amazonaws.com/agreelist/tmp/remain.txt')
    extent = 0
    text = Net::HTTP.get(uri)
    #text.split("\n").each do |line|
    #IO.foreach("../remain.txt") do |line|
    text.split("\n").each do |line|
      wikipedia_line = WikipediaLine.new(line)
      wikipedia_line.read
      if wikipedia_line.wikidata_id
        count = count + 1
        puts count
        puts "@#{wikipedia_line.twitter}" if wikipedia_line.twitter
        puts wikipedia_line.wikidata_id
        puts wikipedia_line.wikipedia_url
        puts wikipedia_line.source
        puts wikipedia_line.bio if wikipedia_line.bio
        unless Individual.exists?(wikidata_id: wikipedia_line.wikidata_id)
          individual = Individual.create(name: wikipedia_line.label, wikidata_id: wikipedia_line.wikidata_id, wikipedia: wikipedia_line.wikipedia_url, twitter: wikipedia_line.twitter, bio: wikipedia_line.bio)
          agreement = Agreement.create(statement: statement, individual: individual, extent: extent, url: wikipedia_line.source)
          puts "agreement_id: #{agreement.id}"
        end
        puts ""
      end
    end
  end
end
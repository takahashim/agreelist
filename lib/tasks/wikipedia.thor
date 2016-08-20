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
    text = Net::HTTP.get(uri)
    #text.split("\n").each do |line|
    #IO.foreach("../remain.txt") do |line|
    text.split("\n").each do |line|
	    title = line.scan(/\[\[([^\]]*)\]\]/).flatten.first
  	  if title
    		title = title.split("|").first if title.include?("|")
    	  wikipedia_url = "https://en.wikipedia.org/wiki/#{title.gsub(' ', '_')}"
    	  source = line.scan(/url=([^\|]*)/).flatten.first
        if source.nil?
          source = "https://en.wikipedia.org/wiki/Endorsements_in_the_United_Kingdom_European_Union_membership_referendum,_2016"
        end
        wikidata = Wikidata::Item.find_by_title(title)
        begin
          wikidata_id = wikidata.id
          bio = wikidata.description.try(:capitalize)
          label = wikidata.label
        rescue
        end
        tw = wikidata.claims_for_property_id("P2002").first
        twitter = tw.mainsnak.value.data_hash.string if tw

        if wikidata_id
          count = count + 1
          puts count
          puts "@#{twitter}" if twitter
          puts wikidata_id
          puts wikipedia_url
          puts source
          puts bio if bio

          unless Individual.exists?(wikidata_id: wikidata_id)
            individual = Individual.create(name: label, wikidata_id: wikidata_id, wikipedia: wikipedia_url, twitter: twitter, bio: bio)
            agreement = Agreement.create(statement: statement, individual: individual, extent: 0, url: source)
            puts "agreement_id: #{agreement.id}"
          end
          puts ""
        end
      end
    end
  end
end
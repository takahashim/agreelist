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

  desc "brexit_import",
       "import Brexit supporters/detractors from wikipedia"
  # Examples:
  # thor wikipedia:brexit_import https://s3-eu-west-1.amazonaws.com/agreelist/tmp/remain.txt remain
  # thor wikipedia:brexit_import https://s3-eu-west-1.amazonaws.com/agreelist/tmp/leave.txt leave

  def brexit_import(url, remain_or_leave)
    require './config/environment'
    count = 0
    statement = Statement.find_by_hashed_id("sblrlc9vgxp7")
    extent = (remain_or_leave == "remain" ? 0 : 100)
    text = Net::HTTP.get(URI(url))
    #IO.foreach("../remain.txt") do |line|
    text.split("\n").each do |line|
      wikipedia_line = WikipediaLine.new(line: line, default_source: "https://en.wikipedia.org/wiki/Endorsements_in_the_United_Kingdom_European_Union_membership_referendum,_2016")
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
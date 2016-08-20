class WikipediaLine
  attr_reader :line, :wikidata_id, :bio, :label

  def initialize(line)
    @line = line
  end

  def read
    if title
      begin
        @wikidata_id = wikidata.id
        @bio = wikidata.description.try(:capitalize)
        @label = wikidata.label
      rescue
      end
    end
  end

  def twitter
    tw = wikidata.claims_for_property_id("P2002").first
    tw ? tw.mainsnak.value.data_hash.string : nil
  end

  def wikipedia_url
    "https://en.wikipedia.org/wiki/#{title.gsub(' ', '_')}"
  end

  def source
    line.scan(/url=([^\|]*)/).flatten.first || default_source
  end

  private

  def wikidata
    @wikidata ||= Wikidata::Item.find_by_title(title)
  end

  def title
    @title ||= (between_brackets.include?("|") ? between_brackets.split("|").first : between_brackets) if between_brackets
  end

  def between_brackets
    @between_brackets ||= line.scan(/\[\[([^\]]*)\]\]/).flatten.first
  end

  def default_source
    "https://en.wikipedia.org/wiki/Endorsements_in_the_United_Kingdom_European_Union_membership_referendum,_2016"
  end
end
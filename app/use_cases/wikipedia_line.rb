class WikipediaLine
  attr_reader :line, :wikidata_id, :bio, :label, :default_source

  def initialize(args)
    @line = args[:line]
    @default_source = args[:default_source]
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
    self
  end

  def twitter
    tw = wikidata.claims_for_property_id("P2002").first
    tw ? tw.mainsnak.value.data_hash.string : nil
  end

  def wikipedia_url
    "https://en.wikipedia.org/wiki/#{title.gsub(' ', '_')}"
  end

  def source
    line.scan(/url=([^\|]*)/).flatten.first.try(:strip) || default_source
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
end
require "rails_helper"

describe WikipediaLine do
  it "should return the name when the title is different from displayed name" do
    wikipedia_line = WikipediaLine.new(line: "*[[Paul Nurse|Sir Paul Nurse]], Laureate, Physiology or Medicine 2001")
    VCR.use_cassette("use_cases/wikipedia_line_paul_nurse") do
      wikipedia_line.read
    end
    expect(wikipedia_line.label).to eq "Paul Nurse"
  end

  it "should return the default source" do
    wikipedia_line = WikipediaLine.new(line: "*[[Paul Nurse|Sir Paul Nurse]], Laureate, Physiology or Medicine 2001", default_source: "http://whatever")
    VCR.use_cassette("use_cases/wikipedia_line_paul_nurse") do
      wikipedia_line.read
    end
    expect(wikipedia_line.source).to eq "http://whatever"
  end

  it "should get basic label" do
    wikipedia_line = WikipediaLine.new(line: "*[[John O'Keefe (neuroscientist)|Professor John O'Keefe]], Laureate, Physiology or Medicine 2014")
    VCR.use_cassette("use_cases/wikipedia_line_john_okeefe") do
      expect(wikipedia_line.read.label).to eq "John O'Keefe"
    end
  end

  it "should get wikipedia_url" do
    wikipedia_line = WikipediaLine.new(line: "*[[John O'Keefe (neuroscientist)|Professor John O'Keefe]], Laureate, Physiology or Medicine 2014")
    VCR.use_cassette("use_cases/wikipedia_line_john_okeefe") do
      expect(wikipedia_line.read.wikipedia_url).to eq "https://en.wikipedia.org/wiki/John_O'Keefe_(neuroscientist)"
    end
  end
  it "should read the url" do
    wikipedia_line = WikipediaLine.new(line: "*[[Barack Obama]], [[President of the United States]] (2009-present)<ref>{{cite web|authors=Rhys Blakely & Tim Montgomerie|url=http://www.thetimes.co.uk/tto/news/world/americas/article4616563.ece |title=Rubio gives Britain his blessing to leave EU|newspaper=The Times of London|date=18 November 2015}}</ref>")
    VCR.use_cassette("use_cases/wikipedia_line_barack_obama") do
      wikipedia_line.read
      expect(wikipedia_line.source).to eq "http://www.thetimes.co.uk/tto/news/world/americas/article4616563.ece"
      expect(wikipedia_line.twitter).to eq "BarackObama"
    end
  end

  it "should read the twitter account" do
    wikipedia_line = WikipediaLine.new(line: "*[[Barack Obama]], [[President of the United States]] (2009-present)<ref>{{cite web|authors=Rhys Blakely & Tim Montgomerie|url=http://www.thetimes.co.uk/tto/news/world/americas/article4616563.ece |title=Rubio gives Britain his blessing to leave EU|newspaper=The Times of London|date=18 November 2015}}</ref>")
    VCR.use_cassette("use_cases/wikipedia_line_barack_obama") do
      wikipedia_line.read
      expect(wikipedia_line.twitter).to eq "BarackObama"
    end
  end

  it "should return the source" do
    wikipedia_line = WikipediaLine.new(line: "* [[Bill Clinton]], 42nd [[President of the United States|President]] (1993–2001)<ref>Fitzpatrick, M. [http://www.cbc.ca/news/world/bill-clinton-says-he-ll-be-backstage-as-hillary-campaigns-1.3028361] Bill Clinton says he'll be 'backstage' as Hillary campaigns ''CBC.'' 2015-04-13.</ref>")
    VCR.use_cassette("use_cases/wikipedia_line_barack_obama") do
      wikipedia_line.read
      expect(wikipedia_line.source).to eq "http://www.cbc.ca/news/world/bill-clinton-says-he-ll-be-backstage-as-hillary-campaigns-1.3028361"
    end
  end
end
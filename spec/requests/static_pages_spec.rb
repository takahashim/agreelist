require 'spec_helper'

describe "Home" do

  subject { page }

  describe "title" do

    it "should have h1" do
      visit "/"
      should have_selector('h1', text: 'Wanna know who agree on something?')
    end
  end

end

describe "Contact" do

  subject { page }

  it "should have contact email" do
    visit "/contact"
    should have_text("feedback@agreelist.com")
  end
end

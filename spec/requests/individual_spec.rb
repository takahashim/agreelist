require 'spec_helper'

describe "Individual" do

  subject { page }

  describe "Show" do
    it "should have h1" do
      visit "/individuals/#{i.id}"
      should have_selector('h1', text: 'Batman')
    end
  end
end

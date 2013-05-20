require 'spec_helper'

describe "Home" do

  subject { page }

  describe "title" do

    it "should have h1" do
      visit "/"
      should have_selector('h1', text: 'Wanna know who agree on something?')
    end
  end

  describe "search" do
    
    it "should find" do
      visit "/"
      s = Statement.create(content: "The world is flat")
      fill_in 'search', with: "The world is flat"
      click_button "Search"
      expect { response.should redirect_to("/search") }
    end
  end
end

require 'spec_helper'

describe "Statement" do

  subject { page }

  describe "Index" do

    it "should have h1" do
      visit "/"
      should have_selector('h1', text: 'Wanna know who agree on something?')
    end
  end
end

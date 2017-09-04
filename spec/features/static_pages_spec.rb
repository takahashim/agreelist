require 'spec_helper'

describe do
  before do
    seed_data
  end

  feature "about" do
    scenario "should have the contact email" do
      visit "/about"
      expect(page).to have_text("hello@agreelist.org")
    end
  end

  feature "faq" do
    scenario "should have the contact email" do
      visit "/faq"
      expect(page).to have_text("hello@agreelist.org")
    end
  end

  feature "contact" do
    context "non logged in" do
      scenario "should send an email" do
        visit "/"
        first(:link, "Contact").click
        fill_in :name, with: "Hector"
        fill_in :email, with: "my@email.com"
        fill_in :body, with: "body body body"
        click_button "Send"
        email = ActionMailer::Base.deliveries.last
        expect(email.to).to eq ["hi@hectorperezarenas.com"]
        expect(email.subject).to eq "contact form"
        expect(email.body.raw_source).to eq "body body body\n\nDetails from sender:\nName: Hector\nEmail: my@email.com\n"
      end
    end

    context "logged in" do
      scenario "should send an email" do
        visit root_path
        visit "/auth/twitter"
        first(:link, "Contact").click
        fill_in :name, with: "Hector"
        fill_in :email, with: "my@email.com"
        fill_in :body, with: "body body body"
        click_button "Send"
        email = ActionMailer::Base.deliveries.last
        expect(email.to).to eq ["hi@hectorperezarenas.com"]
        expect(email.subject).to eq "contact form"
        expect(email.body.raw_source).to eq "body body body\n\nDetails from sender:\nName: Hector\nEmail: my@email.com\nUser logged in as:\nHector Perez\n@arpahector\nhecpeare@gmail.com\n"
      end
    end
  end

  private

  def seed_data
    create(:statement)
    create(:individual, twitter: "arpahector", name: "Hector Perez", email: "hecpeare@gmail.com")
  end
end

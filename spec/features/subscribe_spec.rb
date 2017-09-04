require "spec_helper"

feature "subscribe" do
  before do
    seed_data
  end

  def common
    fill_in :individual_email, with: "hec@tor.com"
    expect{ click_button "Subscribe" }.to change{Individual.count}.by(1)
    expect(Individual.last.email).to eq "hec@tor.com"
    expect(page).to have_content "Subscribed"

    fill_in :individual_password, with: "123456789"
    fill_in :individual_password_confirmation, with: "123456789"
    click_button "Continue"
    expect(Individual.last.password_digest.present?).to eq true
    expect(page).to have_content("Net neutrality")
  end

  scenario "from home page" do
    visit root_path
    common
  end

  scenario "from statement" do
    visit statement_path(@statement)
    common
  end

  def seed_data
    @statement = create(:statement, content: "Net neutrality")
    VCR.use_cassette("wikidata/obama") do
      @individual = create(:individual, wikipedia: "https://en.wikipedia.org/wiki/Barack_Obama")
    end
    create(:agreement, statement: @statement, individual: @individual, extent: 100, reason: "kkk")
  end
end

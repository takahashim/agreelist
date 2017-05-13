require "spec_helper"

describe "Referer blacklist", type: :request do
  before do
    create(:statement)
    create(:individual)
  end

  describe "referer spam" do
    it "is blocked" do
      spammers = ["http://darodar.com", "http://theguardlan.com/"]

      spammers.each do |spammer|
        get root_path, params: {}, headers: { "HTTP_REFERER" => spammer }

        expect(response).to be_forbidden
      end
    end
  end

  describe "regular referer" do
    it "is not blocked" do
      get root_path, params: {}, headers: { "HTTP_REFERER" => "google.com" }

      expect(response).not_to be_redirect
    end
  end

  describe "direct request" do
    it "is not blocked" do
      get root_path
      expect(response).not_to be_redirect
    end
  end
end

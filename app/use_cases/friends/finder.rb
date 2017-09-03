module Friends
  class Finder
    attr_reader :twitter

    def initialize(twitter)
      @twitter = twitter
    end

    def find
      friends_on_twitter & agreelist_users
    end

    private

    def friends_on_twitter
      ::Friends::OnTwitter.new.retrieve(twitter)
    end

    def agreelist_users
      Individual.where("twitter is not null and twitter != ''").pluck(:twitter)
    end
  end
end

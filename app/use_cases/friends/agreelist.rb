module Friends
  class Agreelist
    attr_reader :user

    def initialize(user)
      @user = user
    end

    def find
      friends_on_twitter & agreelist_users
    end

    private

    def friends_on_twitter
      ::Friends::OnTwitter.new.retrieve(user.twitter)
    end

    def agreelist_users
      Individual.all.map(&:twitter)
    end
  end
end

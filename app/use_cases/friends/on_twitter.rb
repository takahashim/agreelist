require 'csv'
module Friends
  class OnTwitter
    def initialize
    end

    SLICE_SIZE = 100

    def retrieve(twitter_username)
      friends = []
      twitter_client.friend_ids(twitter_username).each_slice(SLICE_SIZE) do |slice|
        twitter_client.users(slice).each do |f|
          friends << f.screen_name
        end
      end
      friends
    end

    private

    def twitter_client
      Twitter::REST::Client.new do |config|
        config.consumer_key = ENV['TWITTER_CONSUMER_KEY']
        config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
        config.access_token = ENV['TWITTER_OAUTH_TOKEN']
        config.access_token_secret = ENV['TWITTER_OAUTH_TOKEN_SECRET']
      end
    end
  end
end

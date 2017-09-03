class TwitterFriends < Thor
  desc "follow",
       "follow friends from twitter"
  def follow
    require './config/environment'
    Individual.where("twitter is not null and twitter != '' and email is not null and email != ''").each do |individual|
      puts "@#{individual.twitter} follows:"
      begin
        friends = ::Friends::Finder.new(individual.twitter).find
        friends.each do |twitter_friend|
          puts twitter_friend
          friend = Individual.find_by_twitter(twitter_friend)
          individual.follow(friend)
        end
      rescue => e
        puts "error: #{e.message}"
      end
    end
  end
end

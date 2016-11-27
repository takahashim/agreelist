class Voter
  attr_accessor :voter
  attr_reader :name, :twitter, :current_user, :profession_id, :wikipedia

  def initialize(args)
    @twitter = args[:twitter]
    @name = args[:name]
    @current_user = args[:current_user]
    @profession_id = args[:profession_id]
    @wikipedia = args[:wikipedia].try(:strip)
  end

  def find_or_create!
    find_or_create_voter
    self.voter
  end

  private

  def find_or_create_voter
    self.voter = find_or_build_voter
    self.voter.name = name if name.present?
    self.voter.profession_id = profession_id if profession_id.present?
    self.voter.save!
  end

  def find_or_build_voter
    twitter ? find_or_build_twitter_user : find_user_on_wikipedia || build_user
  end

  def build_user
    Individual.new(name: name)
  end

  def find_twitter_user
    Individual.find_by_twitter(twitter) || Individual.new(twitter: twitter)
  end

  def find_or_build_twitter_user
    Individual.where(twitter: twitter).first || Individual.new(twitter: twitter)
  end

  def find_user_on_wikipedia
    Individual.find_by_wikipedia(wikipedia)
  end
end

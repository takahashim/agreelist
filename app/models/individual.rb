class Individual < ActiveRecord::Base
  has_attached_file :picture, s3_host_name: "s3-eu-west-1.amazonaws.com", :default_url => '/assets/missing-:style.jpg', styles: {
    thumb: '100x100>',
    square: '200x200#',
    medium: '300x300>'
  }
  has_many :agreements, dependent: :destroy
  has_many :statements, :through => :agreements
  has_many :taggings
  has_many :tags, :through => :taggings

  validates :twitter, :presence => true
  validates_attachment_content_type :picture, :content_type => /\Aimage\/.*\Z/

  before_save :update_picture_from_twitter
  before_save :update_name_from_twitter

  def self.create_with_omniauth(auth)
    create! do |user|
      # user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.twitter = auth["info"]["nickname"]
      user.name = auth["info"]["name"]
      user.followers_count = auth["extra"]["raw_info"]["followers_count"]
    end
  end

  def update_name_from_twitter
   if Rails.env == "production" && twitter.present?
      self.name = twitter_client.user(twitter).name
    end
  end

  def update_picture_from_twitter
    if Rails.env == "production" && twitter.present?
      url = twitter_client.user(twitter).profile_image_url_https(:original)
      self.picture = open(url)
    end
  end

  def self.find_or_create(twitter)
    self.find_by_twitter(twitter) || self.create(twitter: twitter)
  end

  def agrees
    agreements.select{ |a| a.extent == 100 }.map{ |i| i.statement }
  end

  def disagrees
    agreements.select{ |a| a.extent == 0 }.map{ |i| i.statement }
  end

  def tag_list
    tags.map(&:name).join(", ")
  end

  def tag_list=(names)
    self.tags = names.split(",").map do |n|
      Tag.where(name: n.strip).first_or_create!
    end
  end

  def self.search(search)
    search.blank? ? [] : self.where("content LIKE ?", "%#{search}%")
  end

  private

  def twitter_client
    # this was in initializers/twitter.rb but heroku didn't find it
    Twitter::REST::Client.new do |config|
      config.consumer_key = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
      config.access_token = ENV['TWITTER_OAUTH_TOKEN']
      config.access_token_secret = ENV['TWITTER_OAUTH_TOKEN_SECRET']
    end
  end
end

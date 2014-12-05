class Individual < ActiveRecord::Base
  attr_accessible :name, :tag_list, :twitter, :picture
  has_attached_file :picture, s3_host_name: "s3-eu-west-1.amazonaws.com", styles: {
    thumb: '100x100>',
    square: '200x200#',
    medium: '300x300>'
  }
  has_many :agreements, dependent: :destroy
  has_many :statements, :through => :agreements
  has_many :taggings
  has_many :tags, :through => :taggings

  validates :name, :presence => true
  validates_attachment_content_type :picture, :content_type => /\Aimage\/.*\Z/

  before_save :update_picture_from_twitter

  def update_picture_from_twitter
    unless twitter.blank?
      url = Twitter.user(twitter).profile_image_url_https(:original)
      self.picture = open(url)
    end
  end

  def self.find_or_create(name)
    self.find_by_name(name) || self.create(name: name)
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

end

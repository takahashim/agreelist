class Statement < ActiveRecord::Base
  attr_accessible :content
  has_many :agreements, dependent: :destroy
  has_many :individuals, :through => :agreements

  validates :content, presence: true, length: { maximum: 140 }

  def agreements_in_favor
    agreements.select{ |a| a.extent == 100 }
  end

  def agreements_against
    agreements.select{ |a| a.extent == 0 }
  end

  def self.search(search)
    search.empty? ? [] : self.where("content LIKE ?", "%#{search}%")
  end
end

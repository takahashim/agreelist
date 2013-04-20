class Statement < ActiveRecord::Base
  attr_accessible :content
  has_many :agreements, dependent: :destroy
  has_many :individuals, :through => :agreements

  validates :content, presence: true, length: { maximum: 140 }
end

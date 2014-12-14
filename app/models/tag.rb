class Tag < ActiveRecord::Base
  has_many :taggings
  has_many :individuals, through: :taggings
end

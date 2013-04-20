class Individual < ActiveRecord::Base
  attr_accessible :name
  has_many :agreements, dependent: :destroy
  has_many :statements, :through => :agreements
end

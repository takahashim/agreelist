class Individual < ActiveRecord::Base
  attr_accessible :name
  has_many :agreements, dependent: :destroy
  has_many :statements, :through => :agreements

  validates :name, :presence => true

  def self.find_or_create(name)
    self.find_by_name(name) || self.create(name: name)
  end
  
  def agrees
    agreements.select{ |a| a.extent == 100 }.map{ |i| i.statement }
  end

  def disagrees
    agreements.select{ |a| a.extent == 0 }.map{ |i| i.statement }
  end
end

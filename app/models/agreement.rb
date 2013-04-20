class Agreement < ActiveRecord::Base
  attr_accessible :individual_id, :statement_id, :url
  validates :individual_id, presence:true
  validates :statement_id, presence:true
  
  belongs_to :statement
  belongs_to :individual
end

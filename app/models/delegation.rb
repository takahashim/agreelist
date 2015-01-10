class Delegation < ActiveRecord::Base
  belongs_to :individual
  belongs_to :agreement
end

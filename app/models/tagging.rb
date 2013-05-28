class Tagging < ActiveRecord::Base
  belongs_to :tag
  belongs_to :individual
  # attr_accessible :title, :body
end

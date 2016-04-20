class Profession < ActiveRecord::Base
  has_many :individuals, dependent: :nullify
end

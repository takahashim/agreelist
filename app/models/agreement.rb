class Agreement < ActiveRecord::Base
  validates :individual_id, presence:true
  validates :statement_id, presence:true

  belongs_to :statement
  belongs_to :individual
  has_many :vias, through: :delegation

  def short_url
    url.gsub(/.*http:\/\//,'').gsub(/.*www\./,'')[0..15] + "..."
  end

  def disagree?
    extent == 0
  end

  def agree?
    extent == 100
  end
end

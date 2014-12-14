class Agreement < ActiveRecord::Base
  validates :individual_id, presence:true
  validates :statement_id, presence:true

  belongs_to :statement
  belongs_to :individual

  def short_url
    url.gsub(/.*http:\/\//,'').gsub(/.*www\./,'')[0..15] + "..."
  end
end

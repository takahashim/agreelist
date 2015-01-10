class Agreement < ActiveRecord::Base
  validates :individual_id, presence:true
  validates :statement_id, presence:true

  belongs_to :statement
  belongs_to :individual

  after_create :rm_opposite_agreement

  def short_url
    url.gsub(/.*http:\/\//,'').gsub(/.*www\./,'')[0..15] + "..."
  end

  def disagree?
    extent == 0
  end

  def agree?
    extent == 100
  end

  private

  def rm_opposite_agreement
    agreement = Agreement.where(statement: statement, individual: individual, extent: opposite_extent).first
    agreement.destroy if agreement
  end

  def opposite_extent
    extent == 100 ? 0 : 100
  end
end

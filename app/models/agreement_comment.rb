class AgreementComment < ActiveRecord::Base
  belongs_to :individual
  belongs_to :agreement

  validates_presence_of :individual_id, :agreement_id, :content
end

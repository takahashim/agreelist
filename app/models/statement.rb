class Statement < ActiveRecord::Base
  has_many :agreements, dependent: :destroy
  has_many :individuals, :through => :agreements

  validates :content, presence: true, length: { maximum: 140 }
  before_create :generate_hashed_id

  def agreements_in_favor
    agreements.select{ |a| a.extent == 100 }
  end
  alias_method :supporters, :agreements_in_favor

  def agreements_against
    agreements.select{ |a| a.extent == 0 }
  end
  alias_method :detractors, :agreements_against

  def to_param
    "#{content.parameterize}-#{hashed_id}"
  end

  private

  def generate_hashed_id
    self.hashed_id = loop do
      token = SecureRandom.urlsafe_base64[0,12].downcase.gsub("-", "a").gsub("_", "b")
      break token unless Statement.where('hashed_id' => token).first.present?
    end
  end
end

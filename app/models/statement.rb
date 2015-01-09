class Statement < ActiveRecord::Base
  has_many :agreements, dependent: :destroy
  has_many :individuals, :through => :agreements

  validates :content, presence: true, length: { maximum: 140 }

  def agreements_in_favor
    agreements.select{ |a| a.extent == 100 }
  end
  alias_method :supporters, :agreements_in_favor

  def agreements_against
    agreements.select{ |a| a.extent == 0 }
  end
  alias_method :detractors, :agreements_against
end

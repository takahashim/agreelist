class Statement < ActiveRecord::Base
  MAXIMUM_LENGTH = 90
  has_many :agreements, dependent: :destroy
  has_many :individuals, :through => :agreements
  has_many :comments
  belongs_to :individual

  acts_as_taggable

  validates :content, presence: true, length: { maximum: MAXIMUM_LENGTH }
  before_create :generate_hashed_id, :set_entrepreneurship_tag

  def agreements_in_favor(args = {})
    filtered_agreements(:agree, args)
  end
  alias_method :supporters, :agreements_in_favor

  def agreements_against(args = {})
    filtered_agreements(:disagree, args)
  end
  alias_method :detractors, :agreements_against

  def supporters_count(args = {})
    filtered_agreements_count(:agree, args)
  end

  def detractors_count(args = {})
    filtered_agreements_count(:disagree, args)
  end

  def to_param
    "#{content.parameterize}-#{hashed_id}"
  end

  private

  def filtered_agreements_count(agree_or_disagree, args)
    a = agreements.where(extent: (agree_or_disagree == :agree ? 100 : 0))
    a = a.joins("left outer join individuals on agreements.individual_id = individuals.id").joins("left outer join professions p on p.id = individuals.profession_id").where("p.name = ?", args[:profession]) if args[:profession]
    if args[:occupation]
      a = a.joins("left outer join individuals on agreements.individual_id = individuals.id")
      a = a.joins("left outer join taggings on taggings.taggable_id = individuals.id")
      a = a.joins("left outer join tags on tags.id = taggings.tag_id")
      a = a.where("taggings.taggable_type = 'Individual'").where("tags.name = '#{args[:occupation]}'").where("taggings.context = 'occupations'")
    end
    a.count
  end

  def filtered_agreements(agree_or_disagree, args)
    a = agreements.where(extent: (agree_or_disagree == :agree ? 100 : 0)).includes(:individual).includes(:upvotes)
    a = a.where(reason_category_id: args[:category_id]) if args[:category_id]
    a = a.where(reason_category_id: nil) if args[:filter_by] == :non_categorized
    a = a.joins("left outer join individuals on agreements.individual_id = individuals.id").joins("left outer join professions p on p.id = individuals.profession_id").where("p.name = ?", args[:profession]) if args[:profession]
    if args[:occupation]
      a = a.joins("left outer join individuals on agreements.individual_id = individuals.id")
      a = a.joins("left outer join taggings on taggings.taggable_id = individuals.id")
      a = a.joins("left outer join tags on tags.id = taggings.tag_id")
      a = a.where("taggings.taggable_type = 'Individual'").where("tags.name = '#{args[:occupation]}'").where("taggings.context = 'occupations'")
    end
    a = a.includes(:agreement_comments)
    # if args[:order] == "date"
    #   a.sort_by{ |a| - a.created_at.to_i }
    # else
    #   a.sort_by{ |a| [- a.upvotes.size, a.individual.email.present? ? 1 : 0, a.reason.present? ? 0 : 1, - ranking(a)] }
    # end
    # a = a.order("count(select upvotes.id from upvotes where agreement_id=agreements.id)")
    if args[:order ] == "date"
      a = a.order("created_at DESC")
    else
      a = a.order("case when agreements.reason is not null THEN 1 END ASC, case when agreements.reason is null THEN 0 END ASC")
      a = a.order("individuals.followers_count DESC")
    end
    a = a.page(args[:page]).per(30)
  end

  def ranking(agreement)
    r = agreement.individual.ranking
    r == 0 ? agreement.individual.followers_count : r
  end

  def generate_hashed_id
    self.hashed_id = loop do
      token = SecureRandom.urlsafe_base64[0,12].downcase.gsub("-", "a").gsub("_", "b")
      break token unless Statement.where('hashed_id' => token).first.present?
    end
  end

  def set_entrepreneurship_tag
    self.tag_list.add("others") unless self.tag_list.any?
  end
end

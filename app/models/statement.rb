class Statement < ActiveRecord::Base
  MAXIMUM_LENGTH = 500
  acts_as_followable
  has_many :agreements, dependent: :destroy
  has_many :individuals, :through => :agreements
  has_many :comments
  belongs_to :individual, optional: true

  acts_as_taggable

  validates :content, presence: true, length: { maximum: MAXIMUM_LENGTH }
  before_create :generate_hashed_id, :set_none_tag

  def to_s
    content
  end

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
    "#{content[0..30].parameterize}-#{hashed_id}"
  end

  def shortened_content(limit)
    if content_with_abbreviations.size > limit
      content_with_abbreviations[0..(limit-4)] + "..."
    else
      content_with_abbreviations
    end
  end

  def content_with_abbreviations
    content.gsub("Advanced Artificial Intelligence", "AI")
  end

  def tags?
    tag_list != ["none"]
  end

  def brexit?
    id == 7
  end

  private

  def filtered_agreements_count(agree_or_disagree, args)
    a = agreements.where(extent: (agree_or_disagree == :agree ? 100 : 0))
    a = a.joins("left outer join individuals on agreements.individual_id = individuals.id").joins("left outer join professions p on p.id = individuals.profession_id").where("p.name = ?", args[:profession]) if args[:profession]
    a = tag_filters(a, args)
    a.count
  end

  def tag_filters(a, args)
    tag = args[:occupation] || args[:educated_at]
    if tag
      context = args[:occupation] ? 'occupations' : 'schools'
      a = tag_joins(a)
      a = a.where("taggings.taggable_type = 'Individual'")
      a = a.where(tags: { name: tag })
      a = a.where(taggings: { context: context })
    else
      a
    end
  end

  def tag_joins(a)
    b = a.joins("left outer join individuals on agreements.individual_id = individuals.id")
    b = b.joins("left outer join taggings on taggings.taggable_id = individuals.id")
    b = b.joins("left outer join tags on tags.id = taggings.tag_id")
  end

  def filtered_agreements(agree_or_disagree, args)
    a = agreements.where(extent: (agree_or_disagree == :agree ? 100 : 0)).includes(:individual).includes(:upvotes)
    a = a.where(reason_category_id: args[:category_id]) if args[:category_id]
    a = a.where(reason_category_id: nil) if args[:filter_by] == :non_categorized
    a = a.joins("left outer join individuals on agreements.individual_id = individuals.id").joins("left outer join professions p on p.id = individuals.profession_id").where("p.name = ?", args[:profession]) if args[:profession]
    a = tag_filters(a, args)
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
      a = a.order("agreements.upvotes_count DESC")
      a = a.order("case when individuals.wikipedia is not null THEN 1 END ASC, case when individuals.wikipedia is null THEN 0 END ASC")
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

  def set_none_tag
    self.tag_list.add("none") unless self.tag_list.any?
  end
end

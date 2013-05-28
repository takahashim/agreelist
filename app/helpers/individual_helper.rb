module IndividualHelper
  def links_to_tags(individual)
    individual.tags.map(&:name).map{ |t| link_to(t, tag_path(t))}.join(", ")
  end

  def tag_path(t)
    "/tags/#{t}"
  end
end

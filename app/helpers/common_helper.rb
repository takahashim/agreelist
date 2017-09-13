module CommonHelper
  def occupation_tag_path(name)
    common_tag_path("occupations", name)
  end

  def school_tag_path(name)
    common_tag_path("schools", name)
  end

  def common_tag_path(tag, name)
    "/#{tag}/#{name.gsub(" ", "-").downcase}"
  end
end

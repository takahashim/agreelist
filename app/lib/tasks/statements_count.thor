class StatementsCount < Thor
  desc "entrepreneurship",
       "update entrepreneurship_statements_count"
  def entrepreneurship
    require './config/environment'
    Individual.all.each do |individual|
      individual.entrepreneurship_statements_count = individual.statements.tagged_with("entrepreneurship").size
      individual.save
    end
  end
end

class IndividualsOpinionsCount < Thor
  desc "update_all",
       "update all opinions_count for all individuals"
  def update_all
    require './config/environment'
    Individual.all.each do |individual|
      puts individual.id
      count = individual.agreements.where("reason is not null and reason != ''").size
      individual.update_columns(opinions_count: count)
    end
  end
end

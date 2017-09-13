class AddOpinionsCountToIndividuals < ActiveRecord::Migration[5.1]
  def change
    add_column :individuals, :opinions_count, :integer, default: 0
  end
end

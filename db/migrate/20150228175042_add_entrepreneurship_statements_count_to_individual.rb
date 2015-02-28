class AddEntrepreneurshipStatementsCountToIndividual < ActiveRecord::Migration
  def change
    add_column :individuals, :entrepreneurship_statements_count, :integer, default: 0
  end
end

class AddWikipediaToIndividual < ActiveRecord::Migration
  def change
  	add_column :individuals, :wikipedia, :string, unique: true, null: true
  end
end

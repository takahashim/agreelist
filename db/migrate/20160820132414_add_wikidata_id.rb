class AddWikidataId < ActiveRecord::Migration
  def change
    add_column :individuals, :wikidata_id, :string, unique: true, allow_nil: true
  end
end

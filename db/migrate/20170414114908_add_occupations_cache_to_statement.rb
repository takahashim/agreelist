class AddOccupationsCacheToStatement < ActiveRecord::Migration
  def change
    add_column :statements, :occupations_cache, :json
  end
end

class RmOccupaitonsCache < ActiveRecord::Migration[5.1]
  def up
    remove_column :statements, :occupations_cache
  end

  def down
    add_column :statements, :occupations_cache, :json
  end
end

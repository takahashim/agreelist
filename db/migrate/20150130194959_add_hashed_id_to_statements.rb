class AddHashedIdToStatements < ActiveRecord::Migration
  def change
    add_column :statements, :hashed_id, :string
    add_index :statements, :hashed_id
  end
end

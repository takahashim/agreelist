class AddIndex < ActiveRecord::Migration
  def change
    add_index :agreements, :hashed_id
  end
end

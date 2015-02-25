class DropTagsTable < ActiveRecord::Migration
  def up
    drop_table :tags
  end

  def down
    create_table do |t|
      t.string :name
    end
  end
end

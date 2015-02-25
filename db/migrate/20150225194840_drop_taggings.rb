class DropTaggings < ActiveRecord::Migration
  def up
    drop_table :taggings
  end

  def down
    create_table :taggings do |t|
      t.string :name
    end
  end
end

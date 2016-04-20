class Professions < ActiveRecord::Migration
  def change
    create_table :professions do |t|
      t.string :name
      t.timestamps
    end
    add_column :individuals, :profession_id, :integer
  end
end

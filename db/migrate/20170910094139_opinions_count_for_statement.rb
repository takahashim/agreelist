class OpinionsCountForStatement < ActiveRecord::Migration[5.1]
  def up
    add_column :statements, :opinions_count, :integer, default: 0
    remove_column :agreements, :opinions_count
  end

  def down
    add_column :agreements, :opinions_count, :integer, default: 0
    remove_column :statements, :opinions_count
  end
end

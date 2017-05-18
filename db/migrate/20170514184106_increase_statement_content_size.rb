class IncreaseStatementContentSize < ActiveRecord::Migration[5.1]
  def change
    change_column :statements, :content, :text
  end
end

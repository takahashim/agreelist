class OldStatementUrl < ActiveRecord::Migration[5.1]
  def change
    create_table :old_statement_urls do |t|
      t.integer :statement_id
      t.string :url

      t.timestamps
    end
  end
end

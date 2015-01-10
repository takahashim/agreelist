class AddDelegationsTable < ActiveRecord::Migration
  def change
    create_table :delegations do |t|
      t.integer :agreement_id
      t.integer :statement_id
      t.timestamps
    end
  end
end

class CreateAgreements < ActiveRecord::Migration
  def change
    create_table :agreements do |t|
      t.string :url
      t.integer :individual_id
      t.integer :statement_id

      t.timestamps
    end
    add_index :agreements, [:statement_id, :created_at]
  end
end

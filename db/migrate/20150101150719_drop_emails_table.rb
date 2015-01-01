class DropEmailsTable < ActiveRecord::Migration
  def up
    drop_table :emails
  end

  def down
    create_table :emails do |t|
      t.string :email

      t.timestamps
    end
  end
end

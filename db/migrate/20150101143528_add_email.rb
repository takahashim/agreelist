class AddEmail < ActiveRecord::Migration
  def change
    add_column :individuals, :email, :string
  end
end

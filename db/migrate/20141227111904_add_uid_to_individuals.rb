class AddUidToIndividuals < ActiveRecord::Migration
  def change
    add_column :individuals, :uid, :string
  end
end

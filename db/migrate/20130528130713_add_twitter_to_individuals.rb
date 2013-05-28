class AddTwitterToIndividuals < ActiveRecord::Migration
  def change
    add_column :individuals, :twitter, :string
  end
end

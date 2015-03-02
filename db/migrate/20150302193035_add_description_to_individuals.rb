class AddDescriptionToIndividuals < ActiveRecord::Migration
  def change
    add_column :individuals, :description, :string
  end
end

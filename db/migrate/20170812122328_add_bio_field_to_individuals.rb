class AddBioFieldToIndividuals < ActiveRecord::Migration[5.1]
  def change
    add_column :individuals, :bio_link, :string
  end
end

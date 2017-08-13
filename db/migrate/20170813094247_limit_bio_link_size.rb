class LimitBioLinkSize < ActiveRecord::Migration[5.1]
  def change
    change_column :individuals, :bio_link, :string, limit: 255
  end
end

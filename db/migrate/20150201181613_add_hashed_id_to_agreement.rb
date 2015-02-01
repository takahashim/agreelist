class AddHashedIdToAgreement < ActiveRecord::Migration
  def change
    add_column :agreements, :hashed_id, :string
  end
end

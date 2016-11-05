class AddedByIdForAgreements < ActiveRecord::Migration
  def change
    add_column :agreements, :added_by_id, :integer
  end
end

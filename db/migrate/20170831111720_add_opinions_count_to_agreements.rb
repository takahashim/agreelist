class AddOpinionsCountToAgreements < ActiveRecord::Migration[5.1]
  def change
    add_column :agreements, :opinions_count, :integer, default: 0
  end
end

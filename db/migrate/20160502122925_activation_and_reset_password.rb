class ActivationAndResetPassword < ActiveRecord::Migration
  def change
    add_column :individuals, :activation_digest, :string
    add_column :individuals, :activated, :boolean, default: false
    add_column :individuals, :activated_at, :datetime
    add_column :individuals, :reset_digest, :string
    add_column :individuals, :reset_sent_at, :datetime
  end
end

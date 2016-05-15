class PasswordDigest < ActiveRecord::Migration
  def change
    add_column :individuals, :password_digest, :string
  end
end

class AddFollowersCount < ActiveRecord::Migration
  def change
    add_column :individuals, :followers_count, :integer
  end
end

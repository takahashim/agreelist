class UpvotesCountForAgreements < ActiveRecord::Migration
  def up
    add_column :agreements, :upvotes_count, :integer, default: 0
    Agreement.all.each{|a| a.update_attributes(upvotes_count: a.upvotes.count)}
  end

  def down
    remove_column :agreements, :upvotes_count
  end
end

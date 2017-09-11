class AddUrlToStatements < ActiveRecord::Migration[5.1]
  def up
    add_column :statements, :url, :string

    Statement.all.each do |s|
      s.generate_url
      s.save
    end
  end

  def down
    remove_column :statements, :url
  end
end

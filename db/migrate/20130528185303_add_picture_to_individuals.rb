class AddPictureToIndividuals < ActiveRecord::Migration
  def self.up
    add_attachment :individuals, :picture
  end

  def self.down
    remove_attachment :individuals, :picture
  end
end

class AddTableAgreementComments < ActiveRecord::Migration
  def change
  	create_table :agreement_comments do |t|
      t.integer :individual_id
      t.integer :agreement_id
      t.text :content
      t.timestamps
  	end
  end
end

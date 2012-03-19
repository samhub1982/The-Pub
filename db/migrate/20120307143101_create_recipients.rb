class CreateRecipients < ActiveRecord::Migration
  def change
    create_table :recipients do |t|
			t.integer :micropost_id
			t.integer :user_id

      t.timestamps
    end
  end
end

class AddProfileInfoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :location, :string

    add_column :users, :birthday, :string

    add_column :users, :about, :string

    add_column :users, :hobbies, :string

  end
end

class AddIndexToUsers < ActiveRecord::Migration[8.0]
  def change
    add_index :users, :name, name: "idx_users_on_name",  unique: true
  end
end

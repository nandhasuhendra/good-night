class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users, id: false do |t|
      t.bigint :id, null: false, primary_key: true
      t.string :name, null: false
      t.string :password_digest, null: false

      t.timestamps
    end
  end
end

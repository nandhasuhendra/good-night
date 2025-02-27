class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users, id: false do |t|
      t.bigint :id, null: false, primary_key: true
      t.string :name

      t.timestamps
    end
  end
end

class CreateFollows < ActiveRecord::Migration[8.0]
  def change
    create_table :follows, id: false do |t|
      t.bigint :id, null: false, primary_key: true
      t.bigint :followed_id, null: false
      t.bigint :following_id, null: false

      t.timestamps
    end

    add_index :follows, %i[following_id followed_id], name: "idx_follows_following_id_followed_id", unique: true
  end
end

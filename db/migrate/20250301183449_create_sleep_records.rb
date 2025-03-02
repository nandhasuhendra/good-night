class CreateSleepRecords < ActiveRecord::Migration[8.0]
  def change
    create_table :sleep_records, id: false do |t|
      t.bigint :id, null: false, primary_key: true
      t.references :user, null: false, foreign_key: true
      t.datetime :clock_in, null: false
      t.datetime :clock_out
      t.integer :sleep_duration 

      t.timestamps
    end

    add_index :sleep_records, %i[user_id clock_in], name: "idx_sleep_records_user_clock_in", unique: true
  end
end

class CreateReportSleepHistories < ActiveRecord::Migration[8.0]
  def change
    create_table :report_sleep_histories, id: false do |t|
      t.bigint :id, primary_key: true, null: false
      t.date :week_start, null: false
      t.integer :total_hours, null: false
      t.integer :average_hours, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :report_sleep_histories, %i[user_id week_start], unique: true
  end
end

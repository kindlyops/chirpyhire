class CreateReminders < ActiveRecord::Migration[5.1]
  def change
    create_table :reminders do |t|
      t.belongs_to :contact, null: false, index: true, foreign_key: true
      t.string :details
      t.boolean :send_day_before_alert, default: true, null: false
      t.boolean :send_hour_before_alert, default: true, null: false
      t.datetime :day_before_alert_sent_at
      t.datetime :hour_before_alert_sent_at
      t.datetime :created_alert_sent_at
      t.datetime :last_updated_alert_sent_at
      t.datetime :destroyed_alert_sent_at
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.datetime :deleted_at
      t.datetime :event_at, null: false
      t.timestamps
    end
  end
end

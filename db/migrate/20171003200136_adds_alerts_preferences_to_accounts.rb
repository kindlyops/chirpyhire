class AddsAlertsPreferencesToAccounts < ActiveRecord::Migration[5.1]
  def change
    change_table :accounts do |t|
      t.boolean :contact_ready, null: false, default: true
      t.boolean :contact_waiting, null: false, default: true
    end
  end
end

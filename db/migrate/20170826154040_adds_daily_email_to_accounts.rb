class AddsDailyEmailToAccounts < ActiveRecord::Migration[5.1]
  def change
    change_table :accounts do |t|
      t.boolean :daily_email, null: false, default: true
    end
  end
end

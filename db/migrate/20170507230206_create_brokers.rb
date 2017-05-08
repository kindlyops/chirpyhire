class CreateBrokers < ActiveRecord::Migration[5.0]
  def change
    create_table :brokers do |t|
      t.string :twilio_account_sid, null: false
      t.string :twilio_auth_token, null: false
      t.string :phone_number, null: false
      t.timestamps null: false
    end

    add_index :brokers, :phone_number, unique: true
  end
end

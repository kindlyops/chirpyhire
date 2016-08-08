class CreateOrganizations < ActiveRecord::Migration[5.0]
  def change
    create_table :organizations do |t|
      t.string :name, null: false
      t.string :twilio_account_sid
      t.string :twilio_auth_token
      t.string :phone_number
      t.timestamps null: false
    end

    add_index :organizations, :phone_number, unique: true
  end
end

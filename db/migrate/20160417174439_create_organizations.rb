class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :name, null: false
      t.string :domain, null: false
      t.string :twilio_account_sid
      t.string :twilio_auth_token
      t.timestamps null: false
    end
  end
end

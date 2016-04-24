class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :name, null: false
      t.string :twilio_account_sid
      t.string :twilio_auth_token
      t.belongs_to :industry, null: false, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end

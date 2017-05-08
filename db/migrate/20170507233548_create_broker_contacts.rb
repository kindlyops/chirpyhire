class CreateBrokerContacts < ActiveRecord::Migration[5.0]
  def change
    create_table :broker_contacts do |t|
      t.belongs_to :person, null: false, index: true, foreign_key: true
      t.belongs_to :broker, null: false, index: true, foreign_key: true
      t.boolean :subscribed, null: false, default: false
      t.datetime :last_reply_at
      t.timestamps
    end

    add_index :broker_contacts, [:person_id, :broker_id], unique: true
  end
end

class CreateConversations < ActiveRecord::Migration[5.0]
  def change
    create_table :conversations do |t|
      t.belongs_to :contact, null: false, index: true, foreign_key: true
      t.belongs_to :account, null: false, index: true, foreign_key: true
      t.timestamps
    end

    add_index :conversations, [:contact_id, :account_id], unique: true
  end
end

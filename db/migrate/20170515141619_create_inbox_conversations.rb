class CreateInboxConversations < ActiveRecord::Migration[5.0]
  def change
    create_table :conversations do |t|
      t.integer :assignee_id
      t.datetime :closed_at
      t.belongs_to :contact, null: false, index: true, foreign_key: true
      t.belongs_to :organization, null: false, index: true, foreign_key: true
      t.integer :status
    end
    
    create_table :inbox_conversations do |t|
      t.belongs_to :inbox, null: false, index: true, foreign_key: true
      t.belongs_to :conversation, null: false, index: true, foreign_key: true
    end
  end
end

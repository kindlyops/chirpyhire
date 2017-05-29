class CreateConversation < ActiveRecord::Migration[5.1]
  def change
    create_table :conversations do |t|
      t.belongs_to :contact, null: false, index: true, foreign_key: true
    end

    change_table :inbox_conversations do |t|
      t.belongs_to :conversation, null: true, index: true, foreign_key: true
    end

    change_table :messages do |t|
      t.belongs_to :conversation, null: true, index: true, foreign_key: true
    end
  end
end

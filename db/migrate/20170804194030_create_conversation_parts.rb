class CreateConversationParts < ActiveRecord::Migration[5.1]
  def change
    create_table :conversation_parts do |t|
      t.belongs_to :conversation, null: false, index: true, foreign_key: true
      t.belongs_to :message, null: false, index: true, foreign_key: true
      t.timestamps
    end
  end
end

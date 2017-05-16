class AddsConversationToMessages < ActiveRecord::Migration[5.0]
  def change
    change_table :messages do |t|
      t.belongs_to :conversation, null: true, index: true, foreign_key: true
    end
  end
end

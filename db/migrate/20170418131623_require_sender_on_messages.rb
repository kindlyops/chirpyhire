class RequireSenderOnMessages < ActiveRecord::Migration[5.0]
  def change
    change_column_null :messages, :sender_id, false
    add_foreign_key :messages, :people, column: :sender_id
    add_foreign_key :messages, :people, column: :recipient_id
    add_index :messages, :sender_id
    add_index :messages, :recipient_id
  end
end

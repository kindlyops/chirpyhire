class RequiresPhoneNumberOnConversations < ActiveRecord::Migration[5.1]
  def change
    change_column_null :conversations, :phone_number_id, false

    remove_index :conversations, name: 'index_conversations_on_state_and_contact_id'
  end
end

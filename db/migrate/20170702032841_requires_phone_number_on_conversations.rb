class RequiresPhoneNumberOnConversations < ActiveRecord::Migration[5.1]
  def change
    change_column_null :conversations, :phone_number_id, false
  end
end

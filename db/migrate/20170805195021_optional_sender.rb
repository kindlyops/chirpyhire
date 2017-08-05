class OptionalSender < ActiveRecord::Migration[5.1]
  def change
    change_column_null :messages, :sender_id, true
  end
end

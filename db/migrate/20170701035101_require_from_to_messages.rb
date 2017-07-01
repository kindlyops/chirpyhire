class RequireFromToMessages < ActiveRecord::Migration[5.1]
  def change
    change_column_null :messages, :from, false
    change_column_null :messages, :to, false
  end
end

class UnsubscribedContactByDefault < ActiveRecord::Migration[5.0]
  def change
    change_column_default :contacts, :subscribed, false
  end
end

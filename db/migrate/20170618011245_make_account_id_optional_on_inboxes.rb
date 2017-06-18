class MakeAccountIdOptionalOnInboxes < ActiveRecord::Migration[5.1]
  def change
    change_column_null :inboxes, :account_id, true
  end
end

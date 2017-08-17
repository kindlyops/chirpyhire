class AddsClosedAtToConversations < ActiveRecord::Migration[5.1]
  def change
    change_table :conversations do |t|
      t.datetime :closed_at
    end
  end
end

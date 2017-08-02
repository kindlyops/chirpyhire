class AddsMessagesCountToContacts < ActiveRecord::Migration[5.1]
  def change
    change_table :contacts do |t|
      t.integer :messages_count, null: false, default: 0
    end
  end
end

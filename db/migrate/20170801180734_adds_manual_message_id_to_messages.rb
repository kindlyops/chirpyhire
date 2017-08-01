class AddsManualMessageIdToMessages < ActiveRecord::Migration[5.1]
  def change
    change_table :messages do |t|
      t.belongs_to :manual_message, null: true, index: true, foreign_key: true
    end
  end
end

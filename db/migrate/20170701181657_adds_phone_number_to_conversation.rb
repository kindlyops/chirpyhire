class AddsPhoneNumberToConversation < ActiveRecord::Migration[5.1]
  def change
    change_table :conversations do |t|
      t.belongs_to :phone_number, null: true, index: true, foreign_key: true
    end

    add_index :conversations, [:state, :contact_id, :phone_number_id], where: 'state = 0', unique: true
  end
end

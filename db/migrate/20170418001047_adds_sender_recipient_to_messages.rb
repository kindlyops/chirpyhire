class AddsSenderRecipientToMessages < ActiveRecord::Migration[5.0]
  def change
    change_table :messages do |t|
      t.integer :sender_id, index: true, foreign_key: true
      t.integer :recipient_id, index: true, foreign_key: true
    end

    change_column_null :accounts, :person_id, false
  end
end

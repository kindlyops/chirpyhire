class AddStateToConversation < ActiveRecord::Migration[5.1]
  def change
    add_column :conversations, :state, :integer, null: false, default: 0

    add_index :conversations, [:state, :contact_id], where: 'state = 0', unique: true
  end
end

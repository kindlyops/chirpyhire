class AddsStatusAndUserToMessages < ActiveRecord::Migration
  def change
    add_reference :messages, :user, null: false, index: true, foreign_key: true
    add_column :messages, :status, :integer, null: false, default: 0
  end
end

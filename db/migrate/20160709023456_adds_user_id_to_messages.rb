# frozen_string_literal: true
class AddsUserIdToMessages < ActiveRecord::Migration[5.0]
  def change
    add_column :messages, :user_id, :integer
    add_index :messages, :user_id
  end
end

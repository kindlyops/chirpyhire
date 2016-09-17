# frozen_string_literal: true
class RemovesMessagesClosureTree < ActiveRecord::Migration[5.0]
  def change
    remove_column :messages, :parent_id, :integer
    drop_table :message_hierarchies
  end
end

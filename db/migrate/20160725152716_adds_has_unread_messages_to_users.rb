# frozen_string_literal: true
class AddsHasUnreadMessagesToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :has_unread_messages, :boolean, default: false, null: false
  end
end

# frozen_string_literal: true
class DropsUserIdFromMessageables < ActiveRecord::Migration[5.0]
  def change
    remove_column :notifications, :user_id, :integer
    remove_column :inquiries, :user_id, :integer
    remove_column :answers, :user_id, :integer
    remove_column :chirps, :user_id, :integer
    change_column :notifications, :message_id, :integer, null: false
    change_column :inquiries, :message_id, :integer, null: false
    change_column :chirps, :message_id, :integer, null: false
    change_column :answers, :message_id, :integer, null: false
    add_foreign_key :notifications, :messages
    add_foreign_key :chirps, :messages
    add_foreign_key :inquiries, :messages
    add_foreign_key :answers, :messages
  end
end

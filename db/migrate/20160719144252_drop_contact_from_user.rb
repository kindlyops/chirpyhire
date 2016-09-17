# frozen_string_literal: true
class DropContactFromUser < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :contact, :boolean, default: false, null: false
  end
end

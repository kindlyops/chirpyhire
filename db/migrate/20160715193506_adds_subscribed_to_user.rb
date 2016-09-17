# frozen_string_literal: true
class AddsSubscribedToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :subscribed, :boolean, default: false, null: false
  end
end

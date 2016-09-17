# frozen_string_literal: true
class AddsIndexToAccounts < ActiveRecord::Migration[5.0]
  def change
    add_index :accounts, [:invited_by_type, :invited_by_id]
  end
end

# frozen_string_literal: true
class AddsTimezoneToOrganizations < ActiveRecord::Migration[5.0]
  def change
    add_column :organizations, :time_zone, :string, default: 'Eastern Time (US & Canada)', null: false
  end
end

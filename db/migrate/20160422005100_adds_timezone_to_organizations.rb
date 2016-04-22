class AddsTimezoneToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :time_zone, :string, default: "Eastern Time (US & Canada)", null: false
  end
end

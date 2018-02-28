class AddTimezoneToOrganizations < ActiveRecord::Migration[5.1]
  def change
    change_table :organizations do |t|
      t.string :time_zone, null: false, default: 'Eastern Time (US & Canada)'
    end
  end
end

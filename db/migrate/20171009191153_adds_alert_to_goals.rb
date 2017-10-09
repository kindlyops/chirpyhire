class AddsAlertToGoals < ActiveRecord::Migration[5.1]
  def change
    change_table :goals do |t|
      t.boolean :alert, null: false, default: true
    end
  end
end

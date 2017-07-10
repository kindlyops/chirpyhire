class AddsOutcomesToGoals < ActiveRecord::Migration[5.1]
  def change
    change_table :goals do |t|
      t.integer :outcome, null: false, default: 1
    end
  end
end

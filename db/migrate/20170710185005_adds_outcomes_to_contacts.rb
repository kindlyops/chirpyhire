class AddsOutcomesToContacts < ActiveRecord::Migration[5.1]
  def change
    change_table :contacts do |t|
      t.integer :outcome, null: false, default: 0
    end
  end
end

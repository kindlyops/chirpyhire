class AddsCustomToSubscriptions < ActiveRecord::Migration[5.1]
  def change
    change_table :subscriptions do |t|
      t.boolean :custom, null: false, default: false
    end
  end
end

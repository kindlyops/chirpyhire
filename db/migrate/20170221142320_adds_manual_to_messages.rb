class AddsManualToMessages < ActiveRecord::Migration[5.0]
  def change
    add_column :messages, :manual, :boolean, null: false, default: false
  end
end

class AddsExternalCreatedAtToMessages < ActiveRecord::Migration[5.0]
  def change
    add_column :messages, :external_created_at, :timestamp, null: true
  end
end

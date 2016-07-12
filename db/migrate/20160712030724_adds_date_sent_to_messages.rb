class AddsDateSentToMessages < ActiveRecord::Migration[5.0]
  def change
    add_column :messages, :sent_at, :datetime
  end
end

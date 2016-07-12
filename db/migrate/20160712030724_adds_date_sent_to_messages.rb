class AddsDateSentToMessages < ActiveRecord::Migration[5.0]
  def change
    add_column :messages, :date_sent, :datetime
  end
end

class AddsNumbersToMessages < ActiveRecord::Migration[5.1]
  def change
    change_table :messages do |t|
      t.string :from
      t.string :to
    end
  end
end

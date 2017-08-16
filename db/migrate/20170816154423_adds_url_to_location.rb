class AddsUrlToLocation < ActiveRecord::Migration[5.1]
  def change
    change_table :locations do |t|
      t.text :url
    end
  end
end

class AddsSourceToContacts < ActiveRecord::Migration[5.1]
  def change
    change_table :contacts do |t|
      t.string :source
    end
  end
end

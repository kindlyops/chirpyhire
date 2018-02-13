class AddsEmailToContacts < ActiveRecord::Migration[5.1]
  def change
    change_table :contacts do |t|
      t.string :email
    end
  end
end

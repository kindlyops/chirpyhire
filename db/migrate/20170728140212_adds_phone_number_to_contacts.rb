class AddsPhoneNumberToContacts < ActiveRecord::Migration[5.1]
  def change
    change_table :contacts do |t|
      t.string :phone_number
    end
  end
end

class AddsForwardingPhoneNumberToPhoneNumbers < ActiveRecord::Migration[5.1]
  def change
    change_table :phone_numbers do |t|
      t.string :forwarding_phone_number
    end
  end
end

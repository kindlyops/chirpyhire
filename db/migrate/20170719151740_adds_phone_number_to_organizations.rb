class AddsPhoneNumberToOrganizations < ActiveRecord::Migration[5.1]
  def change
    change_table :organizations do |t|
      t.string :forwarding_phone_number
    end
  end
end

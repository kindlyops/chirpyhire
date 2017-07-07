class AddsCompanySizeAndPhoneNumberToOrganization < ActiveRecord::Migration[5.1]
  def change
    change_table :organizations do |t|
      t.string :size
    end

    change_table :accounts do |t|
      t.string :phone_number
    end
  end
end

class DropsPhoneFromPerson < ActiveRecord::Migration[5.0]
  def change
    remove_foreign_key :people, :phone_numbers
    drop_table :phone_numbers
    rename_column :people, :phone, :phone_number
  end
end

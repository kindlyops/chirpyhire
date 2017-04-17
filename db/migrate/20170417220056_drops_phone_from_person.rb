class DropsPhoneFromPerson < ActiveRecord::Migration[5.0]
  def change
    remove_column :people, :phone_number_id
    drop_table :phone_numbers
    rename_column :people, :phone, :phone_number
    add_index :people, :phone_number, unique: true
  end
end

class RequiresPhoneNumberOnContacts < ActiveRecord::Migration[5.1]
  def change
    change_column_null :contacts, :phone_number, false
    remove_index :people, :phone_number
  end
end

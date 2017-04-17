class MakePhoneNumberOptional < ActiveRecord::Migration[5.0]
  def change
    change_column_null :people, :phone_number, true
  end
end

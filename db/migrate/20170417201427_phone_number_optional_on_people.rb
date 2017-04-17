class PhoneNumberOptionalOnPeople < ActiveRecord::Migration[5.0]
  def change
    change_column_null :people, :phone_number, true
    change_column_null :candidacies, :person_id, true
  end
end

class UniquePhoneNumberIndex < ActiveRecord::Migration[5.1]
  def change
    add_index :phone_numbers, :phone_number, unique: true
    add_index :assignment_rules, [:organization_id, :phone_number_id, :inbox_id], unique: true, name: 'unique_assignment_rules'
  end
end

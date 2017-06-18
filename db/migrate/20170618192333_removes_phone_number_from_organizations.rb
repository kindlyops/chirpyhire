class RemovesPhoneNumberFromOrganizations < ActiveRecord::Migration[5.1]
  def change
    remove_column :organizations, :phone_number
  end
end

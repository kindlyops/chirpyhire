class DropsPhoneNumberFromTeams < ActiveRecord::Migration[5.1]
  def change
    remove_column :teams, :phone_number, :string
  end
end

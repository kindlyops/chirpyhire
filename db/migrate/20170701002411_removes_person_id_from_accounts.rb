class RemovesPersonIdFromAccounts < ActiveRecord::Migration[5.1]
  def change
    remove_column :accounts, :person_id, :integer
  end
end

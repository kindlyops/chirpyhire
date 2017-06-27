class ChangePersonIdToOptionalOnAccounts < ActiveRecord::Migration[5.1]
  def change
    change_column_null :accounts, :person_id, true
  end
end

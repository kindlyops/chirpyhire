class AddPersonToAccounts < ActiveRecord::Migration[5.0]
  def change
    change_table :accounts do |t|
      t.belongs_to :person, null: true, foreign_key: true, index: true
    end
  end
end

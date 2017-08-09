class AddToAccountsAndContacts < ActiveRecord::Migration[5.1]
  def change
    change_table :accounts do |t|
      t.attachment :avatar
      t.string :name
      t.belongs_to :person, null: true, index: true, foreign_key: true
    end

    change_table :contacts do |t|
      t.belongs_to :zipcode, null: true, index: true, foreign_key: true
    end

    change_column_null :contacts, :person_id, true
    change_column_null :bots, :person_id, true
  end
end

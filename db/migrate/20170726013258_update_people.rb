class UpdatePeople < ActiveRecord::Migration[5.1]
  def change
    change_table :people do |t|
      t.belongs_to :organization, null: true, index: true, foreign_key: true
      t.belongs_to :contact, null: true, index: true, foreign_key: true
    end

    remove_index :people, :phone_number
    add_index :people, [:phone_number, :organization_id], unique: true
  end
end

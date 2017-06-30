class CreatePhoneNumber < ActiveRecord::Migration[5.1]
  def change
    create_table :phone_numbers do |t|
      t.belongs_to :organization, null: false, index: true, foreign_key: true
      t.string :sid, null: false
      t.string :phone_number, null: false
      t.timestamps
    end
  end
end

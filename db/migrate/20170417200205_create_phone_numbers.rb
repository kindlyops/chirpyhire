class CreatePhoneNumbers < ActiveRecord::Migration[5.0]
  def change
    create_table :phone_numbers do |t|
      t.string :phone_number, null: false
      t.timestamps
    end

    change_table :candidacies do |t|
      t.belongs_to :phone_number, null: true, foreign_key: true, index: true
    end
  end
end

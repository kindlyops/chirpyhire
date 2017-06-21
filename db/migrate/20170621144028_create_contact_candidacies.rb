class CreateContactCandidacies < ActiveRecord::Migration[5.1]
  def change
    create_table :contact_candidacies do |t|
      t.integer :experience
      t.boolean :skin_test
      t.integer :availability
      t.integer :transportation
      t.string :zipcode
      t.boolean :cpr_first_aid
      t.integer :certification
      t.belongs_to :contact, null: false, index: true, foreign_key: true
      t.integer :inquiry
      t.integer :state, null: false, default: 0
      t.boolean :live_in
      t.timestamps
    end
  end
end

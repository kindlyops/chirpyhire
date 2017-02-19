class CreateCandidacies < ActiveRecord::Migration[5.0]
  def change
    create_table :candidacies do |t|
      t.integer :experience
      t.integer :skin_test
      t.integer :availability
      t.integer :transportation
      t.string :zipcode
      t.integer :cpr_first_aid
      t.integer :certification
      t.belongs_to :person, null: false, index: true, foreign_key: true
      t.integer :inquiry
      t.timestamps
    end
  end
end

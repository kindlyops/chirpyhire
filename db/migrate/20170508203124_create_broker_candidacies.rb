class CreateBrokerCandidacies < ActiveRecord::Migration[5.0]
  def change
    create_table :broker_candidacies do |t|
      t.integer :experience
      t.boolean :skin_test
      t.integer :availability
      t.integer :transportation
      t.string :zipcode
      t.boolean :cpr_first_aid
      t.integer :certification
      t.belongs_to :person, null: false, index: true, foreign_key: true
      t.integer :inquiry
      t.integer :state, default: 0, null: false
      t.belongs_to :broker_contact, index: true, foreign_key: true
      t.timestamps
    end
  end
end

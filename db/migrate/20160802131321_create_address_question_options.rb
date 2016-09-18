class CreateAddressQuestionOptions < ActiveRecord::Migration[5.0]
  def change
    create_table :address_question_options do |t|
      t.integer :distance, null: false
      t.float :latitude, null: false
      t.float :longitude, null: false
      t.references :question, null: false, index: true, foreign_key: true
      t.timestamps
    end
  end
end

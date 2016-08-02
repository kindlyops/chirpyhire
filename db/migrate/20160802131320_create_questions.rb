class CreateQuestions < ActiveRecord::Migration[5.0]
  def change
    create_table :questions do |t|
      t.references :survey, null: false, index: true, foreign_key: true
      t.references :category, null: false, index: true, foreign_key: true
      t.string :text, null: false
      t.integer :status, null: false, default: 0
      t.integer :priority, null: false
      t.string :type, null: false
      t.timestamps
    end
  end
end

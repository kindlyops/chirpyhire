class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.belongs_to :template, null: false, index: true, foreign_key: true
      t.integer :format, null: false, default: 0
      t.timestamps null: false
    end
  end
end

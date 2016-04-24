class CreateQuestionCategories < ActiveRecord::Migration
  def change
    create_table :question_categories do |t|
      t.string :name, null: false
      t.timestamps null: false
    end

    add_reference :questions, :question_category, null: false, index: true, foreign_key: true
  end
end

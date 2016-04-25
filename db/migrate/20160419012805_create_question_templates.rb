class CreateQuestionTemplates < ActiveRecord::Migration
  def change
    create_table :question_templates do |t|
      t.string :title, null: false
      t.string :body, null: false
      t.string :statement, null: false
      t.integer :category, null: false, default: 0
      t.timestamps null: false
    end
  end
end

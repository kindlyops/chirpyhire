class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :title, null: false
      t.string :body, null: false
      t.string :statement, null: false
      t.integer :category, null: false, default: 0
      t.boolean :custom, null: false, default: true
      t.timestamps null: false
    end
  end
end

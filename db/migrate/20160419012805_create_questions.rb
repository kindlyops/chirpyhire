class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :label, null: false
      t.string :body, null: false
      t.string :summary, null: false
      t.integer :category, null: false, default: 0
      t.timestamps null: false
    end
  end
end

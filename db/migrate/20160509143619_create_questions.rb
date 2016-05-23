class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.belongs_to :template, null: false, index: true, foreign_key: true
      t.belongs_to :action, index: true, foreign_key: true
      t.belongs_to :trigger, foreign_key: true
      t.string :format, null: false
      t.timestamps null: false
    end

    add_index :questions, :trigger_id, unique: true
  end
end

class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.belongs_to :inquiry, null: false, index: true, foreign_key: true
      t.belongs_to :message, null: false, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end

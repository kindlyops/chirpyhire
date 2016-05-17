class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.belongs_to :inquiry, null: false, index: true, foreign_key: true
      t.belongs_to :user, null: false, index: true, foreign_key: true
      t.string :message_sid, null: false
      t.timestamps null: false
    end
  end
end

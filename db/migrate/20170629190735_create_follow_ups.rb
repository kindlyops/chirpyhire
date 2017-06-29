class CreateFollowUps < ActiveRecord::Migration[5.1]
  def change
    create_table :follow_ups do |t|
      t.belongs_to :question, null: false, index: true, foreign_key: true
      t.string :body, null: false
      t.string :response, null: false
      t.timestamps
    end
  end
end

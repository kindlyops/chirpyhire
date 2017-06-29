class CreateGoalsTags < ActiveRecord::Migration[5.1]
  def change
    create_table :goals_tags do |t|
      t.belongs_to :goal, null: false, index: true, foreign_key: true
      t.belongs_to :tag, null: false, index: true, foreign_key: true
      t.timestamps
    end
  end
end

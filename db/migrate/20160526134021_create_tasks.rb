class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.belongs_to :user, null: false, index: true, foreign_key: true
      t.string :category, null: false, index: true, foreign_key: true
      t.boolean :outstanding, null: false, default: true
      t.timestamps null: false
    end

    add_index :tasks, [:user_id, :category], where: "outstanding = 't'", unique: true
  end
end

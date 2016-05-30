class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.belongs_to :user, null: false, index: true, foreign_key: true
      t.string :category, null: false, index: true, foreign_key: true
      t.boolean :done, null: false, default: false
      t.timestamps null: false
    end

    add_index :tasks, [:user_id, :category], where: "done = 'f'", unique: true
  end
end

class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.belongs_to :message, null: false, index: true, foreign_key: true
      t.boolean :done, null: false, default: false
      t.timestamps null: false
    end
  end
end

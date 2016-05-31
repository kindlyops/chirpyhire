class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.belongs_to :user, null: false, index: true, foreign_key: true
      t.references :taskable, polymorphic: true, null: false
      t.boolean :outstanding, null: false, default: true
      t.timestamps null: false
    end
  end
end

class CreateRules < ActiveRecord::Migration
  def change
    create_table :rules do |t|
      t.belongs_to :organization, null: false, index: true, foreign_key: true
      t.belongs_to :trigger, null: false, index: true, foreign_key: true
      t.belongs_to :action, null: false, index: true, foreign_key: true
      t.boolean :enabled, null: false, default: true
      t.timestamps null: false
    end
  end
end

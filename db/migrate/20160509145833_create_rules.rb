class CreateRules < ActiveRecord::Migration
  def change
    create_table :rules do |t|
      t.belongs_to :organization, null: false, index: true, foreign_key: true
      t.boolean :enabled, null: false, default: true
      t.string :event, null: false
      t.integer :trigger_id, index: true
      t.string :trigger_type, null: false
      t.references :action, polymorphic: true, index: true, null: false
      t.timestamps null: false
    end
  end
end

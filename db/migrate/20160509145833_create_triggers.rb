class CreateTriggers < ActiveRecord::Migration
  def change
    create_table :triggers do |t|
      t.belongs_to :organization, null: false, index: true, foreign_key: true
      t.integer :observable_id, index: true
      t.string :observable_type, null: false
      t.string :event, null: false
      t.boolean :enabled, null: false, default: true
      t.timestamps null: false
    end

    add_index :triggers, [:organization_id, :observable_id], where: "observable_type = 'Question'", unique: true
  end
end

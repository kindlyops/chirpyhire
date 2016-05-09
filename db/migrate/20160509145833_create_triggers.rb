class CreateTriggers < ActiveRecord::Migration
  def change
    create_table :triggers do |t|
      t.belongs_to :organization, null: false, index: true, foreign_key: true
      t.string :event, null: false
      t.integer :status, null: false, default: 0
      t.timestamps null: false
    end

    add_index :triggers, [:organization_id, :event], unique: true
  end
end

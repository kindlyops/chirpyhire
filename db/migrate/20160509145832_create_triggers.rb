class CreateTriggers < ActiveRecord::Migration
  def change
    create_table :triggers do |t|
      t.string :event, null: false
      t.belongs_to :organization, null: false, index: true, foreign_key: true
      t.integer :observable_id, index: true
      t.string :observable_type, null: false
      t.timestamps null: false
    end
  end
end

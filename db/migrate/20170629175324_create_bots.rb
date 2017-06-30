class CreateBots < ActiveRecord::Migration[5.1]
  def change
    enable_extension 'citext'
    
    create_table :bots do |t|
      t.belongs_to :organization, null: false, index: true, foreign_key: true
      t.string :name, null: false
      t.citext :keyword, null: false, default: 'start'
      t.datetime :last_edited_at
      t.integer :last_edited_by_id, index: true
      t.timestamps
    end

    add_foreign_key :bots, :accounts, column: :last_edited_by_id
    add_index :bots, [:name, :organization_id], unique: true
  end
end

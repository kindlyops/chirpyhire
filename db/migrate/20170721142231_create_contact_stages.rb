class CreateContactStages < ActiveRecord::Migration[5.1]
  def change
    create_table :contact_stages do |t|
      t.belongs_to :organization, null: false, index: true, foreign_key: true
      t.integer :rank, null: false
      t.string :name, null: false
      t.timestamps
    end

    add_index :contact_stages, [:organization_id, :name], unique: true
    add_index :contact_stages, [:organization_id, :rank], unique: true
    
    change_table :contacts do |t|
      t.belongs_to :contact_stage, index: true, foreign_key: true
    end
  end
end

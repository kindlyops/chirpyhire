class CreateBots < ActiveRecord::Migration[5.1]
  def change
    create_table :bots do |t|
      t.belongs_to :person, null: false, index: true, foreign_key: true
      t.belongs_to :organization, null: false, index: true, foreign_key: true
      t.string :name, null: false
      t.timestamps
    end

    add_index :bots, [:name, :organization_id], unique: true
  end
end

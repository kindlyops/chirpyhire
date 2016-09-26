class CreateStages < ActiveRecord::Migration[5.0]
  def change
    create_table :stages do |t|
      t.references :organization, foreign_key: true, null: false
      t.string :name, null: false
      t.integer :order, null: false
      t.integer :standard_stage_mapping

      t.timestamps
    end
    add_index :stages, [:organization_id, :order], unique: true
    add_index :stages, [:organization_id, :name], unique: true
  end
end

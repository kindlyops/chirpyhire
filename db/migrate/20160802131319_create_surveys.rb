class CreateSurveys < ActiveRecord::Migration[5.0]
  def change
    create_table :surveys do |t|
      t.integer :organization_id, null: false
      t.references :actionable, null: true, index: true, foreign_key: true
      t.references :template, null: true, index: true, foreign_key: true
      t.timestamps
    end

    add_index :surveys, :organization_id, unique: true
    add_foreign_key :surveys, :organizations
  end
end

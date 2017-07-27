class CreateColumnMappings < ActiveRecord::Migration[5.1]
  def change
    create_table :column_mappings do |t|
      t.belongs_to :import, null: false, index: true, foreign_key: true
      t.string :contact_attribute, null: false
      t.integer :column_number
      t.boolean :optional, null: false
      t.timestamps
    end
  end
end

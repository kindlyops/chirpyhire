class CreateColumnMappings < ActiveRecord::Migration[5.1]
  def change
    create_table :column_mappings do |t|
      t.belongs_to :import, null: false, index: true, foreign_key: true
      t.string :attribute, null: false
      t.string :column
      t.boolean :optional, null: false
      t.timestamps
    end
  end
end

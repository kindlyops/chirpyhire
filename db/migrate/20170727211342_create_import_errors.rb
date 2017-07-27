class CreateImportErrors < ActiveRecord::Migration[5.1]
  def change
    create_table :import_errors do |t|
      t.belongs_to :import, null: false, index: true, foreign_key: true
      t.integer :row_number, null: false
      t.integer :column_number, null: false
      t.integer :type, null: false
      t.string :column_name
      t.timestamps
    end
  end
end

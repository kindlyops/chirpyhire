class CreateImportsTags < ActiveRecord::Migration[5.1]
  def change
    create_table :imports_tags do |t|
      t.belongs_to :import, null: false, index: true, foreign_key: true
      t.belongs_to :tag, null: false, index: true, foreign_key: true
      t.timestamps
    end

    add_index :imports_tags, [:import_id, :tag_id], unique: true
  end
end

class CreateContactsImports < ActiveRecord::Migration[5.1]
  def change
    create_table :contacts_imports do |t|
      t.belongs_to :contact, null: false, index: true, foreign_key: true
      t.belongs_to :import, null: false, index: true, foreign_key: true
      t.boolean :updated, null: false, default: false
      t.timestamps
    end
  end
end

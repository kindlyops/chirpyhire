class AddsContentToContacts < ActiveRecord::Migration[5.0]
  def change
    change_table :contacts do |t|
      t.text :content
      t.tsvector :content_tsearch
      t.boolean :candidate, null: false, default: false
    end

    add_index :contacts, :content_tsearch, using: :gin
  end
end

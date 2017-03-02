class AddsNotReadyContentToContacts < ActiveRecord::Migration[5.0]
  def change
    change_table :contacts do |t|
      t.text :not_ready_content
      t.tsvector :not_ready_content_tsearch
    end
  end
end

class AddsInboxableAssociationToInboxes < ActiveRecord::Migration[5.1]
  def change
    change_table :inboxes do |t|
      t.references :inboxable, polymorphic: true, index: true
    end
  end
end

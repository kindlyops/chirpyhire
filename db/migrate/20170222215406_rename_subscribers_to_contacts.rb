class RenameSubscribersToContacts < ActiveRecord::Migration[5.0]
  def change
    rename_table :subscribers, :contacts
    rename_column :candidacies, :subscriber_id, :contact_id
  end
end

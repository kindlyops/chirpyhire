class AddsScreenedToContacts < ActiveRecord::Migration[5.0]
  def change
    add_column :contacts, :screened, :boolean, null: false, default: false
  end
end

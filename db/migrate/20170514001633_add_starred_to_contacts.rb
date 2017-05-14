class AddStarredToContacts < ActiveRecord::Migration[5.0]
  def change
    add_column :contacts, :starred, :boolean, null: false, default: false
  end
end

class RemovesTeamsFromContacts < ActiveRecord::Migration[5.1]
  def change
    remove_column :contacts, :team_id, :integer
    change_column_null :contacts, :organization_id, false
  end
end

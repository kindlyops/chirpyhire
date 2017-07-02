class RequiresOrganizationsOnContacts < ActiveRecord::Migration[5.1]
  def change
    change_column_null :contacts, :team_id, true
    change_column_null :contacts, :organization_id, false
  end
end

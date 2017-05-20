class AddFieldsToTeams < ActiveRecord::Migration[5.1]
  def change
    add_column :teams, :description, :string
  end
end

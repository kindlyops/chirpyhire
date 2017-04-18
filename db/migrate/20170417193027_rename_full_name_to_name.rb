class RenameFullNameToName < ActiveRecord::Migration[5.0]
  def change
    rename_column :people, :full_name, :name
  end
end

class AddFieldsToTeams < ActiveRecord::Migration[5.1]
  def change
    change_table :teams do |t|
      t.attachment :avatar
      t.string :description
    end
  end
end

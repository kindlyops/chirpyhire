class RemovesPersonFromMessages < ActiveRecord::Migration[5.0]
  def change
    remove_column :messages, :person_id, :integer
    remove_column :messages, :manual, :boolean
  end
end

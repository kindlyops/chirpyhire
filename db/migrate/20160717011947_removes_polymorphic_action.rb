class RemovesPolymorphicAction < ActiveRecord::Migration[5.0]
  def change
    remove_column :rules, :action_type, :string
    remove_column :rules, :action_id, :integer
  end
end

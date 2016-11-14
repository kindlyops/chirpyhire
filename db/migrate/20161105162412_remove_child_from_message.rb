class RemoveChildFromMessage < ActiveRecord::Migration[5.0]
  def change
    remove_column(:messages, :child_id)
  end
end

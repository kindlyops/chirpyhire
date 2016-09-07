class AddUniqueIndexToStages < ActiveRecord::Migration[5.0]
  def up
    add_index :stage, [:organization_id, :order], unique: true
  end

  def down
    remove_index :stage, column: [:organization_id, :order]
  end
end

class AddUniqueIndexToStages < ActiveRecord::Migration[5.0]
  def up
    add_index :stages, [:organization_id, :order], unique: true
  end

  def down
    remove_index :stages, column: [:organization_id, :order]
  end
end

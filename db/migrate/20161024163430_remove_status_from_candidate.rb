class RemoveStatusFromCandidate < ActiveRecord::Migration[5.0]
  def change
    remove_column :candidates, :status
    change_column_null :candidates, :stage_id, false
  end
end

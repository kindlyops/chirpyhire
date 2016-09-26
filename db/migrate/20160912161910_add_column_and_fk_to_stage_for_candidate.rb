class AddColumnAndFkToStageForCandidate < ActiveRecord::Migration[5.0]
  def change
    add_reference(:candidates, :stage, foreign_key: true)
  end
end

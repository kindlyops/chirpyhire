class RequiresLabels < ActiveRecord::Migration[5.0]
  def change
    change_column :questions, :label, :string, null: false
    change_column :candidate_features, :label, :string, null: false
  end
end

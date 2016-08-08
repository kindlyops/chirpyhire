class AddsLabelToCandidateFeatures < ActiveRecord::Migration[5.0]
  def change
    add_column :candidate_features, :label, :string
  end
end

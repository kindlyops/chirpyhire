class RemovesIdealCandidates < ActiveRecord::Migration[5.1]
  def change
    drop_table :ideal_candidate_suggestions
    drop_table :ideal_candidate_zipcodes
    drop_table :ideal_candidates
    remove_column :locations, :organization_id
    drop_table :candidacies
  end
end

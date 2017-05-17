class RemovesIdealCandidate < ActiveRecord::Migration[5.1]
  def change
    drop_table :ideal_candidate_zipcodes
    drop_table :ideal_candidates
  end
end

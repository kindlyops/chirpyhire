class RenameZipcodesToIdealCandidateZipcodes < ActiveRecord::Migration[5.0]
  def change
    rename_table :zipcodes, :ideal_candidate_zipcodes
  end
end

class CreateIdealCandidateSuggestions < ActiveRecord::Migration[5.0]
  def change
    create_table :ideal_candidate_suggestions do |t|
      t.belongs_to :organization, null: false, index: true, foreign_key: true
      t.text :value, null: false
      t.timestamps
    end
  end
end

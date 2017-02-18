class CreateIdealCandidates < ActiveRecord::Migration[5.0]
  def change
    create_table :ideal_candidates do |t|
      t.belongs_to :organization, null: false, index: true, foreign_key: true
      t.timestamps
    end
  end
end

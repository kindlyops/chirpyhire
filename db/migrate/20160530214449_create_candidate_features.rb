class CreateCandidateFeatures < ActiveRecord::Migration
  def change
    create_table :candidate_features do |t|
      t.belongs_to :feature, null: false, index: true, foreign_key: true
      t.belongs_to :candidate, null: false, index: true, foreign_key: true
      t.integer :status, null: false, default: 0
      t.timestamps null: false
    end
  end
end

class CreateCandidateFeatures < ActiveRecord::Migration
  def change
    create_table :candidate_features do |t|
      t.belongs_to :candidate, null: false, index: true, foreign_key: true
      t.belongs_to :feature, null: false, index: true, foreign_key: true
      t.timestamps null: false
    end

    add_reference :inquiries, :candidate_feature, null: false, index: true, foreign_key: true
  end
end

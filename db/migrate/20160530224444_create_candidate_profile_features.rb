class CreateCandidateProfileFeatures < ActiveRecord::Migration
  def change
    create_table :candidate_profile_features do |t|
      t.belongs_to :candidate_profile, null: false, index: true, foreign_key: true
      t.belongs_to :ideal_feature, null: false, index: true, foreign_key: true
      t.jsonb :properties, null: false, default: '{}'
      t.timestamps null: false
    end

    add_index  :candidate_profile_features, :properties, using: :gin
    add_reference :inquiries, :candidate_profile_feature, null: false, index: true, foreign_key: true
  end
end

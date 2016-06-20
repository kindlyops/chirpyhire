class CreateCandidateFeatures < ActiveRecord::Migration
  def change
    create_table :candidate_features do |t|
      t.belongs_to :candidate, null: false, index: true, foreign_key: true
      t.belongs_to :persona_feature, null: false, index: true, foreign_key: true
      t.jsonb :properties, null: false, default: '{}'
      t.timestamps null: false
    end

    add_index  :candidate_features, :properties, using: :gin
    add_reference :inquiries, :candidate_feature, null: false, index: true, foreign_key: true
  end
end

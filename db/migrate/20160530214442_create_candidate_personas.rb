# frozen_string_literal: true
class CreateCandidatePersonas < ActiveRecord::Migration
  def change
    create_table :candidate_personas do |t|
      t.belongs_to :organization, null: false, foreign_key: true
      t.timestamps null: false
    end

    add_reference :candidates, :candidate_persona, null: false, index: true, foreign_key: true
    add_index :candidate_personas, :organization_id, unique: true
  end
end

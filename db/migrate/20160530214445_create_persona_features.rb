class CreatePersonaFeatures < ActiveRecord::Migration[5.0]
  def change
    create_table :persona_features do |t|
      t.belongs_to :candidate_persona, null: false, index: true, foreign_key: true
      t.string :format, null: false
      t.string :name, null: false
      t.timestamps null: false
    end
  end
end

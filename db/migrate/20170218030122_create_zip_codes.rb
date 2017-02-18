class CreateZipCodes < ActiveRecord::Migration[5.0]
  def change
    create_table :zip_codes do |t|
      t.string :value, null: false
      t.belongs_to :ideal_candidate, null: false, index: true, foreign_key: true
      t.timestamps
    end

    add_index :zip_codes, [:ideal_candidate_id, :value], unique: true
  end
end

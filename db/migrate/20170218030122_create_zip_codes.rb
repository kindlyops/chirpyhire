class CreateZipCodes < ActiveRecord::Migration[5.0]
  def change
    create_table :zip_codes do |t|
      t.string :zip_code, null: false
      t.belongs_to :ideal_candidate, null: false, index: true, foreign_key: true
      t.timestamps
    end

    add_index :zip_codes, [:ideal_candidate_id, :zip_code], unique: true
  end
end

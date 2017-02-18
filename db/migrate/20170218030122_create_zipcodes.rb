class CreateZipcodes < ActiveRecord::Migration[5.0]
  def change
    create_table :zipcodes do |t|
      t.string :value, null: false
      t.belongs_to :ideal_candidate, null: false, index: true, foreign_key: true
      t.timestamps
    end

    add_index :zipcodes, [:ideal_candidate_id, :value], unique: true
  end
end

class CreateIdealFeatures < ActiveRecord::Migration
  def change
    create_table :ideal_features do |t|
      t.belongs_to :ideal_profile, null: false, index: true, foreign_key: true
      t.string :format, null: false
      t.string :name, null: false
      t.timestamps null: false
    end
  end
end

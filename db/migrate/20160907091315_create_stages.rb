class CreateStages < ActiveRecord::Migration[5.0]
  def change
    create_table :stages do |t|
      t.references :organization, foreign_key: true
      t.string :name
      t.integer :order

      t.timestamps
    end
  end
end

class CreateToys < ActiveRecord::Migration[5.0]
  def change
    create_table :toys do |t|
      t.string :name
      t.integer :animal_id
      t.timestamps
    end
    add_index :toys, :animal_id
  end
end

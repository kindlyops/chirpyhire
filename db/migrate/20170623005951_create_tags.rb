class CreateTags < ActiveRecord::Migration[5.1]
  def change
    create_table :tags do |t|
      t.string :name, null: false
      t.belongs_to :organization, null: false, index: true, foreign_key: true
      t.timestamps
    end

    add_index :tags, [:organization_id, :name], unique: true
  end
end

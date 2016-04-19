class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.belongs_to :organization, null: false, index: true, foreign_key: true
      t.string :label, null: false
      t.integer :status, null: false, default: 0
      t.timestamps null: false
    end
  end
end

class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.belongs_to :account, null: false, index: true, foreign_key: true
      t.string :title, null: false
      t.timestamps null: false
    end
  end
end

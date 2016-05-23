class CreateTriggers < ActiveRecord::Migration
  def change
    create_table :triggers do |t|
      t.string :event, null: false
      t.belongs_to :organization, null: false, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end

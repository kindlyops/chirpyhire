class CreateTriggers < ActiveRecord::Migration
  def change
    create_table :triggers do |t|
      t.belongs_to :rule, null: false, index: true, foreign_key: true
      t.string :event, null: false
      t.timestamps null: false
    end
  end
end

class CreateRules < ActiveRecord::Migration
  def change
    create_table :rules do |t|
      t.belongs_to :automation, null: false, index: true, foreign_key: true
      t.integer :status, null: false, default: 0
      t.timestamps null: false
    end
  end
end

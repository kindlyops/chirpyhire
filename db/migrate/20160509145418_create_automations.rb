class CreateAutomations < ActiveRecord::Migration
  def change
    create_table :automations do |t|
      t.string :name, null: false
      t.belongs_to :organization, null: false, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end

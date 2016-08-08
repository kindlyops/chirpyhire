class CreateRules < ActiveRecord::Migration[5.0]
  def change
    create_table :rules do |t|
      t.belongs_to :organization, null: false, index: true, foreign_key: true
      t.string :trigger, null: false
      t.references :action, polymorphic: true, index: true
      t.boolean :enabled, null: false, default: true
      t.timestamps null: false
    end
  end
end

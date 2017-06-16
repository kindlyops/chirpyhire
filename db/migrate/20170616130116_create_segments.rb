class CreateSegments < ActiveRecord::Migration[5.1]
  def change
    create_table :segments do |t|
      t.belongs_to :account, null: false, index: true, foreign_key: true
      t.string :name, null: false
      t.jsonb :form, null: false
      t.timestamps
    end
  end
end

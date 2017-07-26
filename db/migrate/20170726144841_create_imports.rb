class CreateImports < ActiveRecord::Migration[5.1]
  def change
    create_table :imports do |t|
      t.belongs_to :account, null: false, index: true, foreign_key: true
      t.integer :state, null: false, default: 0
      t.attachment :file
      t.timestamps
    end
  end
end

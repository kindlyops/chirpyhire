class CreateNotes < ActiveRecord::Migration[5.0]
  def change
    create_table :notes do |t|
      t.string :body, null: false
      t.belongs_to :conversation, null: false, index: true, foreign_key: true
      t.timestamps
    end
  end
end

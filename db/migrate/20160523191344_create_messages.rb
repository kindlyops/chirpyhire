class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.string :sid, null: false
      t.text :body
      t.string :direction, null: false
      t.belongs_to :messageable, polymorphic: true, null: false, index: true
      t.timestamps null: false
    end

    add_index :messages, :sid, unique: true
  end
end

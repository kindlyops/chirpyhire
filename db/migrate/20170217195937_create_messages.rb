class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.string :sid, null: false
      t.text :body
      t.string :direction, null: false
      t.datetime :sent_at
      t.datetime :external_created_at
      t.belongs_to :organization, null: false, index: true, foreign_key: true
      t.belongs_to :person, null: false, index: true, foreign_key: true
      t.timestamps
    end

    add_index :messages, :sid, unique: true
  end
end

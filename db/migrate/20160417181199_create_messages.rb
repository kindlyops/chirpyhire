class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :sid, null: false, unique: true
      t.jsonb :properties, null: false, default: '{}'
      t.timestamps null: false
    end

    add_index :messages, :properties, using: :gin
  end
end

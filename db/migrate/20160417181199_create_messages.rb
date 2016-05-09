class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :sid, null: false, unique: true
      t.text :media_url
      t.timestamps null: false
    end
  end
end

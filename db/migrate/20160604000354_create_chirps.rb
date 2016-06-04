class CreateChirps < ActiveRecord::Migration
  def change
    create_table :chirps do |t|
      t.belongs_to :message, null: false, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end

class CreateActions < ActiveRecord::Migration
  def change
    create_table :actions do |t|
      t.belongs_to :organization, null: false, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end

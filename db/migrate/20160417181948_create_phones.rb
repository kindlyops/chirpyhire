class CreatePhones < ActiveRecord::Migration
  def change
    create_table :phones do |t|
      t.belongs_to :organization, null: false, index: true, foreign_key: true
      t.string :title, null: false
      t.string :number, null: false
      t.timestamps null: false
    end
  end
end

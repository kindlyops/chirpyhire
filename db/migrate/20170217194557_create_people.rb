class CreatePeople < ActiveRecord::Migration[5.0]
  def change
    create_table :people do |t|
      t.string :full_name
      t.string :nickname, null: false
      t.string :phone_number, null: false
      t.timestamps null: false
    end
  end
end

class CreatePeople < ActiveRecord::Migration[5.0]
  def change
    create_table :people do |t|
      t.string :full_name
      t.string :nick_name, null: false
      t.string :phone_number
      t.timestamps null: false
    end
  end
end

class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name, default: ""
      t.string :last_name, default: ""
      t.string :phone_number, null: false
      t.timestamps null: false
    end
  end
end

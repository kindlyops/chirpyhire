class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :phone_number
      t.boolean :contact, null: false, default: false
      t.belongs_to :organization, null: false, index: true, foreign_key: true
      t.timestamps null: false
    end

    add_index :users, [:contact, :organization_id], where: "contact = 't'", unique: true
  end
end

class CreateTeams < ActiveRecord::Migration[5.1]
  def change
    create_table :teams do |t|
      t.belongs_to :organization, null: false, index: true, foreign_key: true
      t.string :name, null: false
      t.string :phone_number, null: true
      t.integer :recruiter_id, index: true, foreign_key: true
      t.timestamps
    end

    change_table :contacts do |t|
      t.belongs_to :team, null: true, index: true, foreign_key: true
    end

    change_table :recruiting_ads do |t|
      t.belongs_to :team, null: true, index: true, foreign_key: true
    end

    change_table :locations do |t|
      t.belongs_to :team, null: true, index: true, foreign_key: true
    end

    add_index :teams, [:name, :organization_id], unique: true
    add_index :teams, :phone_number, unique: true
  end
end

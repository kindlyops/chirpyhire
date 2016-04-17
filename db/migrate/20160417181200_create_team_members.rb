class CreateTeamMembers < ActiveRecord::Migration
  def change
    create_table :team_members do |t|
      t.belongs_to :user, null: false, index: true, foreign_key: true
      t.belongs_to :organization, null: false, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end

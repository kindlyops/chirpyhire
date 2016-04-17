class CreateTeamMembers < ActiveRecord::Migration
  def change
    create_table :team_members do |t|
      t.belongs_to :user, null: false, foreign_key: true, index: true
      t.belongs_to :organization, null: false, foreign_key: true, index: true
      t.timestamps null: false
    end
  end
end

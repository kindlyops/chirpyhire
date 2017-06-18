class CreateTeamInboxes < ActiveRecord::Migration[5.1]
  def change
    create_table :team_inboxes do |t|
      t.belongs_to :team, null: false, index: true, foreign_key: true
      t.timestamps
    end
  end
end

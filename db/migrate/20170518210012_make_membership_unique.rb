class MakeMembershipUnique < ActiveRecord::Migration[5.1]
  def change
    add_index :memberships, [:account_id, :team_id], unique: true
  end
end

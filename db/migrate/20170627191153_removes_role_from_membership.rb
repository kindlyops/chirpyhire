class RemovesRoleFromMembership < ActiveRecord::Migration[5.1]
  def change
    remove_column :memberships, :role, :integer
  end
end

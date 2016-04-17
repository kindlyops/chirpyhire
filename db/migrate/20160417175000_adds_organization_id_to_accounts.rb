class AddsOrganizationIdToAccounts < ActiveRecord::Migration
  def change
    add_reference :accounts, :organization, index: true, foreign_key: true
  end
end

class AddsAffiliateTagToAccounts < ActiveRecord::Migration[5.1]
  def change
    change_table :accounts do |t|
      t.string :affiliate_tag
    end

    change_table :organizations do |t|
      t.integer :referrer_id, index: true
    end

    add_foreign_key :organizations, :accounts, column: :referrer_id
  end
end

class AddsMessageToReferrals < ActiveRecord::Migration
  def change
    add_reference :referrals, :message, null: false, index: true, foreign_key: true
  end
end

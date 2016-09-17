# frozen_string_literal: true
class CreateReferrals < ActiveRecord::Migration[5.0]
  def change
    create_table :referrals do |t|
      t.belongs_to :candidate, null: false, index: true, foreign_key: true
      t.belongs_to :referrer, null: false, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end

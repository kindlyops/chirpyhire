class CreateReferrals < ActiveRecord::Migration
  def change
    create_table :referrals do |t|
      t.belongs_to :lead, null: false, index: true, foreign_key: true
      t.belongs_to :referrer, null: false, index: true, foreign_key: true
      t.belongs_to :message, null: false, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end

class CreateReferrals < ActiveRecord::Migration
  def change
    create_table :referrals do |t|
      t.belongs_to :lead, null: false, index: true, foreign_key: true
      t.belongs_to :referrer, null: false, index: true, foreign_key: true
      t.string :message_sid, null: false
      t.timestamps null: false
    end
  end
end

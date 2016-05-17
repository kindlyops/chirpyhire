class CreateReferrers < ActiveRecord::Migration
  def change
    create_table :referrers do |t|
      t.belongs_to :user, null: false, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end

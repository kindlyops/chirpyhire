class CreateCandidates < ActiveRecord::Migration
  def change
    create_table :candidates do |t|
      t.belongs_to :user, null: false, index: true, foreign_key: true
      t.string :status, null: false, default: "Potential"
      t.integer :profile_status, null: false, default: 0
      t.boolean :subscribed, null: false, default: false
      t.timestamps null: false
    end
  end
end

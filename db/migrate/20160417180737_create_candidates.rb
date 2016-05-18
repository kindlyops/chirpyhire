class CreateCandidates < ActiveRecord::Migration
  def change
    create_table :candidates do |t|
      t.belongs_to :user, null: false, index: true, foreign_key: true
      t.string :status, null: false, default: "potential"
      t.boolean :subscribed, null: false, default: false
      t.timestamps null: false
    end
  end
end

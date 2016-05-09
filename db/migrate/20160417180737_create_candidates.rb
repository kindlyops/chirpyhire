class CreateCandidates < ActiveRecord::Migration
  def change
    create_table :candidates do |t|
      t.belongs_to :user, null: false, index: true, foreign_key: true
      t.integer :status, null: false, default: 0
      t.timestamps null: false
    end
  end
end

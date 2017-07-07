class RecreateSubscriptions < ActiveRecord::Migration[5.1]
  def change
    create_table :subscriptions do |t|
      t.belongs_to :organization, null: false, index: true, foreign_key: true
      t.integer  :status, null: false, default: 0
      t.timestamps
    end
  end
end

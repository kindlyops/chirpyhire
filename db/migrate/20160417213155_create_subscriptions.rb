class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.belongs_to :candidate, null: false, foreign_key: true
      t.datetime :deleted_at
      t.timestamps null: false
    end

    add_index :subscriptions, :candidate_id, where: "deleted_at IS NULL", unique: true
  end
end

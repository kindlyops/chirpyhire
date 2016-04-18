class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :organization, null: false, foreign_key: true
      t.datetime :deleted_at
      t.timestamps null: false
    end

    add_index :subscriptions, :organization_id, where: "deleted_at IS NULL"
    add_index :subscriptions, :user_id, where: "deleted_at IS NULL"
  end
end

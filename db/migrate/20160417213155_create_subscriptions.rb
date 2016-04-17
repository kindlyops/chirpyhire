class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.belongs_to :lead, null: false, foreign_key: true
      t.datetime :deleted_at
      t.timestamps null: false
    end

    add_index :subscriptions, :lead_id, where: "deleted_at IS NULL"
  end
end

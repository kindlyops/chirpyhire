# frozen_string_literal: true
class CreatePlans < ActiveRecord::Migration[5.0]
  def change
    create_table :plans do |t|
      t.integer :amount, null: false
      t.string :interval, null: false
      t.string :name, null: false
      t.string :stripe_id, null: false
      t.integer :interval_count
      t.integer :trial_period_days

      t.timestamps
    end

    add_index :plans, :stripe_id, unique: true
  end
end

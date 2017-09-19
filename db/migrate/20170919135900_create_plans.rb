class CreatePlans < ActiveRecord::Migration[5.1]
  def change
    create_table :plans do |t|
      t.string :stripe_id
      t.string :object
      t.integer :amount
      t.integer :created
      t.string :currency
      t.string :interval
      t.integer :interval_count
      t.boolean :livemode
      t.jsonb :metadata, default: {}
      t.string :name
      t.string :statement_descriptor
      t.integer :trial_period_days
      t.timestamps
    end

    add_index :plans, :stripe_id, unique: true
    add_index :plans, :name, unique: true
  end
end

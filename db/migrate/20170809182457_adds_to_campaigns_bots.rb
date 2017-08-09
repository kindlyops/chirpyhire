class AddsToCampaignsBots < ActiveRecord::Migration[5.1]
  def change
    change_table :bots do |t|
      t.belongs_to :account, null: true, index: true, foreign_key: true
      t.integer :last_edited_by_id, null: true, index: true
      t.datetime :last_edited_at, null: true
    end

    add_foreign_key :bots, :accounts, column: :last_edited_by_id

    change_table :campaigns do |t|
      t.belongs_to :account, null: true, index: true, foreign_key: true
      t.integer :status, null: false, default: 0
      t.datetime :last_edited_at, null: true
      t.integer :last_edited_by_id, null: true, index: true
    end

    add_foreign_key :campaigns, :accounts, column: :last_edited_by_id
  end
end

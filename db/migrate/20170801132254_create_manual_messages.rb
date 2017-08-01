class CreateManualMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :manual_messages do |t|
      t.belongs_to :account, null: false, index: true, foreign_key: true
      t.integer :status, null: false, default: 0
      t.text :body, null: false
      t.string :title, null: false
      t.datetime :started_sending_at
      t.jsonb :audience, null: false
      t.timestamps
    end
  end
end

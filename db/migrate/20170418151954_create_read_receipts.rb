class CreateReadReceipts < ActiveRecord::Migration[5.0]
  def change
    create_table :read_receipts do |t|
      t.belongs_to :conversation, null: false, index: true, foreign_key: true
      t.belongs_to :message, null: false, index: true, foreign_key: true
      t.datetime :read_at
      t.timestamps
    end
  end
end

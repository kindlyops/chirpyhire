class CreateInboxes < ActiveRecord::Migration[5.1]
  def change
    create_table :inboxes do |t|
      t.belongs_to :account, null: false, index: true, foreign_key: true
      t.timestamps
    end
  end
end

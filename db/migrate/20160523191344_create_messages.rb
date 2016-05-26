class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :sid, null: false
      t.belongs_to :user, null: false, index: true, foreign_key: true
      t.timestamps null: false
    end

    remove_column :answers, :user_id
    remove_column :inquiries, :user_id
    remove_column :notifications, :user_id
    remove_column :answers, :message_sid
    remove_column :inquiries, :message_sid
    remove_column :notifications, :message_sid

    add_index :messages, :sid, unique: true

    add_reference :answers, :message, null: false, index: true, foreign_key: true
    add_reference :inquiries, :message, null: false, index: true, foreign_key: true
    add_reference :notifications, :message, null: false, index: true, foreign_key: true
  end
end

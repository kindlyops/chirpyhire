class CreateInquiries < ActiveRecord::Migration
  def change
    create_table :inquiries do |t|
      t.belongs_to :user, null: false, index: true, foreign_key: true
      t.string :message_sid, null: false
      t.timestamps null: false
    end
  end
end

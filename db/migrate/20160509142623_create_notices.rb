class CreateNotices < ActiveRecord::Migration
  def change
    create_table :notices do |t|
      t.belongs_to :template, null: false, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end

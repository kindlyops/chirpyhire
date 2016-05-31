class CreateMediaInstances < ActiveRecord::Migration
  def change
    create_table :media_instances do |t|
      t.string :sid, null: false
      t.string :content_type, null: false
      t.text :uri, null: false
      t.belongs_to :message, null: false, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end

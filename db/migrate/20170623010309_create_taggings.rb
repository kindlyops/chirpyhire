class CreateTaggings < ActiveRecord::Migration[5.1]
  def change
    create_table :taggings do |t|
      t.belongs_to :contact, null: false, index: true, foreign_key: true
      t.belongs_to :tag, null: false, index: true, foreign_key: true
      t.timestamps
    end

    add_index :taggings, [:contact_id, :tag_id], unique: true
  end
end

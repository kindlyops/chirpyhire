class CreateInquiries < ActiveRecord::Migration[5.0]
  def change
    create_table :inquiries do |t|
      t.belongs_to :candidacy, null: false, index: true, foreign_key: true
      t.belongs_to :message, null: false, index: true, foreign_key: true

      t.timestamps
    end
  end
end

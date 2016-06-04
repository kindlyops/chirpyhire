class CreateInquiries < ActiveRecord::Migration
  def change
    create_table :inquiries do |t|
      t.timestamps null: false
    end
  end
end

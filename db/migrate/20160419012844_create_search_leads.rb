class CreateSearchLeads < ActiveRecord::Migration
  def change
    create_table :search_leads do |t|
      t.belongs_to :search, null: false, index: true, foreign_key: true
      t.belongs_to :lead, null: false, index: true, foreign_key: true
      t.integer :status, null: false, default: 0
      t.integer :fit, null: false, default: 0
      t.timestamps null: false
    end
  end
end

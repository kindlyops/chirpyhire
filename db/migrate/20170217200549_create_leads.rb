class CreateLeads < ActiveRecord::Migration[5.0]
  def change
    create_table :leads do |t|
      t.belongs_to :person, null: false, index: true, foreign_key: true
      t.belongs_to :organization, null: false, index: true, foreign_key: true
      t.boolean :subscribed, null: false, default: true
      t.timestamps
    end
  end
end

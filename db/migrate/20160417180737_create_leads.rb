class CreateLeads < ActiveRecord::Migration
  def change
    create_table :leads do |t|
      t.belongs_to :user, null: false, index: true, foreign_key: true
      t.belongs_to :organization, null: false, index: true, foreign_key: true
      t.boolean :sms_opt_in, null: false, default: false, index: true
      t.integer :relationship, null: false, default: 0
      t.timestamps null: false
    end
  end
end

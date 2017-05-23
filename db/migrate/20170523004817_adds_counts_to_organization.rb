class AddsCountsToOrganization < ActiveRecord::Migration[5.1]
  def change
    change_table :contacts do |t|
      t.boolean :screened, null: false, default: false
      t.boolean :reached, null: false, default: false
    end

    change_table :organizations do |t|
      t.integer :contacts_count, null: false, default: 0
      t.integer :screened_contacts_count, null: false, default: 0
      t.integer :reached_contacts_count, null: false, default: 0
      t.integer :starred_contacts_count, null: false, default: 0
    end
  end
end

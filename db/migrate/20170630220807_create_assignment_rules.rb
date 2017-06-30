class CreateAssignmentRules < ActiveRecord::Migration[5.1]
  def change
    create_table :assignment_rules do |t|
      t.belongs_to :organization, null: false, index: true, foreign_key: true
      t.belongs_to :inbox, null: false, index: true, foreign_key: true
      t.belongs_to :phone_number, null: false, index: true, foreign_key: true
      t.timestamps
    end
  end
end

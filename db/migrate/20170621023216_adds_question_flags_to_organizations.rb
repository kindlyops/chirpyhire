class AddsQuestionFlagsToOrganizations < ActiveRecord::Migration[5.1]
  def change
    change_table :organizations do |t|
      t.boolean :certification, default: true, null: false
      t.boolean :availability, default: true, null: false
      t.boolean :live_in, default: true, null: false
      t.boolean :experience, default: true, null: false
      t.boolean :transportation, default: true, null: false
      t.boolean :zipcode, default: true, null: false
      t.boolean :cpr_first_aid, default: true, null: false
      t.boolean :skin_test, default: true, null: false
    end
  end
end

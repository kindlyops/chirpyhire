class AddsEditableToContactStages < ActiveRecord::Migration[5.1]
  def change
    change_table :contact_stages do |t|
      t.boolean :editable, null: false, default: true
    end
  end
end

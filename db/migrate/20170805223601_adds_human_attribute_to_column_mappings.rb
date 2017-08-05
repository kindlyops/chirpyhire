class AddsHumanAttributeToColumnMappings < ActiveRecord::Migration[5.1]
  def change
    change_table :column_mappings do |t|
      t.string :human_attribute, null: true
    end
  end
end

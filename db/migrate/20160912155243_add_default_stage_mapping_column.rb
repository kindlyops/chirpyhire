class AddDefaultStageMappingColumn < ActiveRecord::Migration[5.0]
  def change
    add_column :stages, :default_stage_mapping, :integer
  end
end

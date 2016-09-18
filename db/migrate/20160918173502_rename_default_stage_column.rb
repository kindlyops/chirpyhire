class RenameDefaultStageColumn < ActiveRecord::Migration[5.0]
  def change
    rename_column :stages, :default_stage_mapping, :standard_stage_mapping
  end
end

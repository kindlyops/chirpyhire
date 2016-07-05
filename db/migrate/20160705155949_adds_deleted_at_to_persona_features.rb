class AddsDeletedAtToPersonaFeatures < ActiveRecord::Migration
  def change
    add_column :persona_features, :deleted_at, :datetime
    add_index :persona_features, :deleted_at
  end
end

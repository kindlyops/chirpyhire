class AddsStateToCandidacy < ActiveRecord::Migration[5.0]
  def change
    add_column :candidacies, :state, :integer, null: false, default: 0
  end
end

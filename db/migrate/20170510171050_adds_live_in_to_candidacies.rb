class AddsLiveInToCandidacies < ActiveRecord::Migration[5.0]
  def change
    add_column :candidacies, :live_in, :boolean
    add_column :broker_candidacies, :live_in, :boolean
  end
end

class RelaxUniqueRankOnContactStages < ActiveRecord::Migration[5.1]
  def change
    remove_index :contact_stages, [:organization_id, :rank]
  end
end

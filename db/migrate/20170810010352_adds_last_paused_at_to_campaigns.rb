class AddsLastPausedAtToCampaigns < ActiveRecord::Migration[5.1]
  def change
    change_table :campaigns do |t|
      t.datetime :last_paused_at
      t.datetime :last_active_at
    end
  end
end

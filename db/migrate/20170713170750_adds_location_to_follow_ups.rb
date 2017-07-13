class AddsLocationToFollowUps < ActiveRecord::Migration[5.1]
  def change
    change_table :follow_ups do |t|
      t.boolean :location, null: false, default: true
    end
  end
end

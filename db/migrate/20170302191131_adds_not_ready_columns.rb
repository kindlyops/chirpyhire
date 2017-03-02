class AddsNotReadyColumns < ActiveRecord::Migration[5.0]
  def change
    change_table :contacts do |t|
      t.datetime :last_activity_at
    end

    change_table :candidacies do |t|
      t.float :progress, null: false, default: 0.0
    end
  end
end

class DropsUserIdFromMessageables < ActiveRecord::Migration[5.0]
  def change
    remove_column :notifications, :user_id, :integer
    remove_column :inquiries, :user_id, :integer
    remove_column :answers, :user_id, :integer
    remove_column :chirps, :user_id, :integer
  end
end

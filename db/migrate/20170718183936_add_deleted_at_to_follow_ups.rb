class AddDeletedAtToFollowUps < ActiveRecord::Migration[5.1]
  def change
    add_column :follow_ups, :deleted_at, :datetime
    add_index :follow_ups, :deleted_at
  end
end

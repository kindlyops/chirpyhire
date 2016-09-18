# Migration responsible for creating a table with activities
class CreateActivities < ActiveRecord::Migration[5.0]
  # Create table
  def self.up
    create_table :activities do |t|
      t.belongs_to :trackable, polymorphic: true, null: false
      t.belongs_to :owner, polymorphic: true, null: false
      t.string  :key, null: false
      t.text    :parameters
      t.belongs_to :recipient, polymorphic: true
      t.boolean :outstanding, null: false, default: false
      t.timestamps
    end

    add_index :activities, [:trackable_id, :trackable_type]
    add_index :activities, [:owner_id, :owner_type]
    add_index :activities, [:recipient_id, :recipient_type]
  end
  # Drop table
  def self.down
    drop_table :activities
  end
end

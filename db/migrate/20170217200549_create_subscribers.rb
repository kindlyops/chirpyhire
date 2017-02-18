class CreateSubscribers < ActiveRecord::Migration[5.0]
  def change
    create_table :subscribers do |t|
      t.belongs_to :person, null: false, index: true, foreign_key: true
      t.belongs_to :organization, null: false, index: true, foreign_key: true
      t.boolean :subscribed, null: false, default: true
      t.timestamps
    end

    add_column :candidacies, :subscriber_id, :integer, index: true, foreign_key: true
    add_index :subscribers, [:person_id, :organization_id], unique: true
  end
end

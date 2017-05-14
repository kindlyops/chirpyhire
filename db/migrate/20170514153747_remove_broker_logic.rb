class RemoveBrokerLogic < ActiveRecord::Migration[5.0]
  def change
    drop_table :broker_candidacies
    drop_table :broker_contacts
    drop_table :brokers
    change_column_null :messages, :organization_id, false
    remove_column :messages, :broker_id
  end
end

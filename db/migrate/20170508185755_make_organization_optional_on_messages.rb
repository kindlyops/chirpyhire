class MakeOrganizationOptionalOnMessages < ActiveRecord::Migration[5.0]
  def change
    add_column :messages, :broker_id, :integer, index: true, foreign_key: true
    change_column_null :messages, :organization_id, true
  end
end

class AddAccountToPeople < ActiveRecord::Migration[5.1]
  def change
    add_column :people, :account_id, :integer
  end
end

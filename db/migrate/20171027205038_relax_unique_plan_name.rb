class RelaxUniquePlanName < ActiveRecord::Migration[5.1]
  def change
    remove_index :plans, :name
  end
end

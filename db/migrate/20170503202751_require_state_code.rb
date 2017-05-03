class RequireStateCode < ActiveRecord::Migration[5.0]
  def change
    change_column_null :locations, :state_code, false
  end
end

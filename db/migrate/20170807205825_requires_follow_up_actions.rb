class RequiresFollowUpActions < ActiveRecord::Migration[5.1]
  def change
    change_column_null :follow_ups, :bot_action_id, false
  end
end

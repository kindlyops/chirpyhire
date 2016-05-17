class CreateActions < ActiveRecord::Migration
  def change
    create_table :actions do |t|
      t.belongs_to :trigger, null: false, index: true, foreign_key: true
      t.references :actionable, polymorphic: true, index: true, null: false
      t.timestamps null: false
    end

    add_index :actions, :trigger_id, where: "actionable_type = 'Question'", unique: true, name: "index_unique_question_action_per_trigger"
  end
end

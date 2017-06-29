class CreateFollowUpsTags < ActiveRecord::Migration[5.1]
  def change
    create_table :follow_ups_tags do |t|
      t.belongs_to :follow_up, null: false, index: true, foreign_key: true
      t.belongs_to :tag, null: false, index: true, foreign_key: true
      t.timestamps
    end
  end
end

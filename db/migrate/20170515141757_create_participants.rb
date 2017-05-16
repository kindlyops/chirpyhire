class CreateParticipants < ActiveRecord::Migration[5.0]
  def change
    create_table :participants do |t|
      t.belongs_to :conversation, null: false, index: true, foreign_key: true
      t.belongs_to :account, null: false, index: true, foreign_key: true
      t.timestamps
    end
  end
end

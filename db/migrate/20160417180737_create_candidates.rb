# frozen_string_literal: true
class CreateCandidates < ActiveRecord::Migration[5.0]
  def change
    create_table :candidates do |t|
      t.belongs_to :user, null: false, index: true, foreign_key: true
      t.string :status, null: false, default: 'Potential'
      t.boolean :screened, null: false, default: false
      t.boolean :subscribed, null: false, default: false
      t.timestamps null: false
    end
  end
end

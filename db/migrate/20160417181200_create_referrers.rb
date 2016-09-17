# frozen_string_literal: true
class CreateReferrers < ActiveRecord::Migration[5.0]
  def change
    create_table :referrers do |t|
      t.belongs_to :user, null: false, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end

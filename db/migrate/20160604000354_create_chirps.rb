# frozen_string_literal: true
class CreateChirps < ActiveRecord::Migration[5.0]
  def change
    create_table :chirps do |t|
      t.belongs_to :user, null: false, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end

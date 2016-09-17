# frozen_string_literal: true
class CreateAnswers < ActiveRecord::Migration[5.0]
  def change
    create_table :answers do |t|
      t.belongs_to :inquiry, null: false, index: true, foreign_key: true
      t.belongs_to :user, null: false, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end

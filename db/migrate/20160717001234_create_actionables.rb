# frozen_string_literal: true
class CreateActionables < ActiveRecord::Migration[5.0]
  def change
    create_table :actionables do |t|
      t.string :type, null: false, index: true
      t.timestamps
    end
  end
end

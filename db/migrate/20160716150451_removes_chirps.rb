# frozen_string_literal: true
class RemovesChirps < ActiveRecord::Migration[5.0]
  def change
    drop_table :chirps
  end
end

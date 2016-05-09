class AddsUserToMessages < ActiveRecord::Migration
  def change
    add_reference :messages, :user, null: false, index: true, foreign_key: true
  end
end

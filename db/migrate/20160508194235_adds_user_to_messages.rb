class AddsUserToMessages < ActiveRecord::Migration
  def change
    add_reference :messages, :user, index: true, null: false
  end
end

class AddsMessageableToMessages < ActiveRecord::Migration
  def change
    add_reference :messages, :messageable, polymorphic: true, index: true, null: false
  end
end

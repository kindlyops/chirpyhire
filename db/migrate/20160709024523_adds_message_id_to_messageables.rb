class AddsMessageIdToMessageables < ActiveRecord::Migration[5.0]
  def change
    add_reference :notifications, :message
    add_reference :answers, :message
    add_reference :inquiries, :message
    add_reference :chirps, :message
  end
end

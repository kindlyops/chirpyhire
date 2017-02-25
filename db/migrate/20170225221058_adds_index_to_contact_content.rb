class AddsIndexToContactContent < ActiveRecord::Migration[5.0]
  disable_ddl_transaction!
  def change
    add_index :contacts, :content_tsearch, where: "contacts.candidate = 't'", using: :gin, algorithm: :concurrently
  end
end

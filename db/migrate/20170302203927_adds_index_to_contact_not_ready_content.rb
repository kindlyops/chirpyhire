class AddsIndexToContactNotReadyContent < ActiveRecord::Migration[5.0]
  disable_ddl_transaction!
  def change
    add_index :contacts, :not_ready_content_tsearch, where: "contacts.candidate = 'f'", using: :gin, algorithm: :concurrently
  end
end

class RemoveCandidateFromContacts < ActiveRecord::Migration[5.0]
  def change
    remove_column :contacts, :candidate
  end
end

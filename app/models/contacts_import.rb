class ContactsImport < ApplicationRecord
  belongs_to :contact
  belongs_to :import

  def self.created
    where(updated: false)
  end

  def self.updated
    where(updated: true)
  end
end

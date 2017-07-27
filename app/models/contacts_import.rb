class ContactsImport < ApplicationRecord
  belongs_to :contact
  belongs_to :import
end

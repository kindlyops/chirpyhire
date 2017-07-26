class Import < ApplicationRecord
  belongs_to :account
  has_many :column_mappings
  has_many :imports_tags
  has_many :tags, through: :imports_tags

  has_attached_file :file

  validates_attachment :file, presence: true,
                   content_type: {
                     content_type: [
                       'text/plain',
                       'text/csv',
                       'application/vnd.ms-excel',
                       'application/octet-stream'
                     ]
                   },
                   file_name: { matches: /csv/ }
end

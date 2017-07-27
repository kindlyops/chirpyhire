class Import < ApplicationRecord
  belongs_to :account
  has_many :mappings, class_name: 'ColumnMapping'
  has_many :imports_tags
  has_many :tags, through: :imports_tags

  has_attached_file :document

  validates_attachment :document, presence: true,
                                  content_type: {
                                    content_type: [
                                      'text/plain',
                                      'text/csv',
                                      'application/vnd.ms-excel',
                                      'application/octet-stream'
                                    ]
                                  },
                                  file_name: { matches: /csv/ }

  def first_mapping
    first_attribute = Import::Create.mapping_attributes.first[:attribute]

    mappings.find_by(contact_attribute: first_attribute)
  end

  def mapping_number(mapping)
    mappings.order(:id).to_a.find_index { |m| m.id == mapping.id } + 1
  end

  def mapping_after(mapping)
    mappings.order(:id).to_a[mapping_number(mapping)]
  end

  def select_columns
    headers.zip(0...headers.size)
  end

  def document_columns
    headers.map.with_index { |h, i| Import::Column.new(h, i, local_doc) }
  end

  private

  def headers
    @headers ||= CSV.foreach(local_doc.path).first
  end

  def local_doc
    @local_doc ||= Paperclip.io_adapters.for(document)
  end
end

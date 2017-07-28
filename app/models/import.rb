class Import < ApplicationRecord
  include AASM
  belongs_to :account
  has_many :mappings, class_name: 'ColumnMapping'
  has_many :imports_tags
  has_many :tags, through: :imports_tags

  has_many :contacts_imports
  has_many :contacts, through: :contacts_imports

  has_many :import_errors

  has_attached_file :document

  enum status: { pending: 0, in_progress: 1, complete: 2 }

  aasm column: :status, enum: true do
    state :pending, initial: true
    state :in_progress, :complete

    event :run, after: :import do
      transitions from: :pending, to: :in_progress, if: :valid_mappings?
    end
  end

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
  
  delegate :organization, to: :account
  
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

  def mapping_before(mapping)
    number = mapping_number(mapping)
    return if number == 1
    mappings.order(:id).to_a[number - 2]
  end

  def select_columns
    headers.zip(0...headers.size)
  end

  def document_columns
    headers.map.with_index { |h, i| Import::Column.new(h, i, local_document) }
  end

  def load_mapping_errors
    mappings.find_each { |mapping| mapping.load_error(self) }
  end

  def local_document
    @local_document ||= Paperclip.io_adapters.for(document)
  end

  private

  def import
    ImportJob.perform_later(self)
  end

  def valid_mappings?
    mappings.find_each.all?(&:valid_for_import?)
  end

  def headers
    @headers ||= CSV.foreach(local_document.path).first
  end
end

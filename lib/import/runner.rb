class Import::Runner
  def self.call(import)
    new(import).call
  end

  def initialize(import)
    @import = import
  end

  attr_reader :import

  def call
    CSV.foreach(local_document.path, headers: true, &method(:import_contact))
  end

  def import_contact(row)
    Import::Runner::Contact.call(self, row)
  end

  def id_mapping
    @id_mapping ||= import.mappings.find_by(contact_attribute: 'id')
  end

  def phone_number_mapping
    @phone_number_mapping ||= begin
      import.mappings.find_by(contact_attribute: 'phone_number')
    end
  end

  def name_mapping
    @name_mapping ||= import.mappings.find_by(contact_attribute: 'name')
  end

  delegate :local_document, :organization, to: :import
end

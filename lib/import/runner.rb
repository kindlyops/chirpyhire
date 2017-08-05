class Import::Runner
  def self.call(import)
    new(import).call
  end

  def initialize(import)
    @import = import
  end

  attr_reader :import

  def call
    CSV
      .foreach(local_document.path, headers: true)
      .with_index(1, &method(:import_contact))

    import.update(status: :complete)
  end

  def import_contact(row, row_number)
    Import::Runner::ContactRunner.call(self, row, row_number)
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

  def stage_mapping
    @stage_mapping ||= begin
      import.mappings.find_by(contact_attribute: 'contact_stage_id')
    end
  end

  delegate :local_document, :organization, to: :import
end

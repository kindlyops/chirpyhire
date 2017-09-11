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
      .foreach(local_document.path, csv_configuration)
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

  def source_mapping
    @source_mapping ||= import.mappings.find_by(contact_attribute: 'source')
  end

  def stage_mapping
    @stage_mapping ||= begin
      import.mappings.find_by(contact_attribute: 'stage')
    end
  end

  delegate :local_document, :organization, to: :import

  private

  def csv_configuration
    return { headers: true } if encoding_detector.blank?

    { headers: true,
      encoding: "#{internal_encoding}:UTF-8" }
  end

  def internal_encoding
    encoding = encoding_detector[:encoding]
    return encoding if encoding != 'UTF-8'
    "BOM|#{encoding}"
  end

  def encoding_detector
    @encoding_detector ||= begin
      CharlockHolmes::EncodingDetector.detect(contents)
    end
  end

  def contents
    File.read(local_document.path)
  end
end

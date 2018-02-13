class Import::Create
  def self.call(import)
    new(import).call
  end

  def self.mapping_attributes
    [
      { attribute: 'phone_number', optional: false },
      { attribute: 'id', optional: true },
      { attribute: 'email', optional: true },
      { attribute: 'name', optional: true },
      { attribute: 'stage', optional: true },
      { attribute: 'source', optional: true }
    ]
  end

  def initialize(import)
    @import = import
  end

  attr_reader :import

  def call
    import.save && create_mappings
  end

  private

  def create_mappings
    mapping_attributes.each(&method(:create_mapping))
  end

  def create_mapping(attribute:, optional:)
    mappings.find_or_create_by(contact_attribute: attribute, optional: optional)
  end

  def mapping_attributes
    self.class.mapping_attributes
  end

  delegate :mappings, to: :import
end

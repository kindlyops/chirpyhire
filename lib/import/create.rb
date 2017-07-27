class Import::Create
  def self.call(import)
    new(import).call
  end

  def self.mapping_attributes
    [
      { attribute: 'contact_id', optional: true },
      { attribute: 'phone_number', optional: false },
      { attribute: 'name', optional: true }
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
    mappings.find_or_create_by(attribute: attribute, optional: optional)
  end

  def mapping_attributes
    self.class.mapping_attributes
  end

  delegate :mappings, to: :import
end

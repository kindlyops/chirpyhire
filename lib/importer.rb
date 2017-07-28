class Importer
  def self.call(import)
    new(import).call
  end

  def initialize(import)
    @import = import
  end

  attr_reader :import

  def call
    # For each row of CSV look for ID or Phone Number
    # ID is present in CSV
    # And ID exists in ChirpyHire then use that contact and update
    # And ID does not exist in ChirpyHire
    # And phone number is not present in CSV
    # then create an error
    # And phone number is present in CSV
    # then create a new contact
    # ID is not present in CSV
    # Phone number is present in CSV
    # And exists in CH, use contact and update
    # And does not exist in CH, create contact
    # Phone number is not present in CSV
    # then create an error
  end
end

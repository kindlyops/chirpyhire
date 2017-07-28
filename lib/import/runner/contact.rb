class Import::Runner::Contact
  def self.call(runner, row)
    new(runner, row).call
  end

  def initialize(runner, row)
    @runner = runner
    @row = row
  end

  def call
    if existing_contact.present?
      existing_contact.update(update_params)
      # TODO: invalid phone number or missing phone number error
    else
      contacts.create(phone_number: phone_number, name: name)
      # TODO: invalid phone number or missing phone number error
    end
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

  def existing_contact
    @existing_contact ||= begin
      contact = contacts.find_by(id: id)
      contact ||= contacts.joins(:person).find_by(people: { phone_number: phone_number })
    end
  end

  def person
    @person ||= Person.find_or_create_by(phone_number: phone_number)
  end

  def update_params
    params = {}
    params[:phone_number] = phone_number if phone_number.present?
    params[:name] = name if name.present?
    params
  end

  def id
    @id ||= row[id_mapping.column_number]
  end

  def phone_number
    @phone_number ||= row[phone_number_mapping.column_number]
  end

  def name
    @name ||= row[name_mapping.column_number]
  end

  attr_reader :row, :runner

  delegate :organization, :phone_number_mapping, :name_mapping, 
           :id_mapping, to: :runner
  delegate :contacts, to: :organization
end

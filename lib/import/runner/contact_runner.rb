class Import::Runner::ContactRunner
  def self.call(runner, row, row_number)
    new(runner, row, row_number).call
  end

  def initialize(runner, row, row_number)
    @runner = runner
    @row = row
    @row_number = row_number
  end

  def call
    return phone_import_error(:blank_phone_number) if phone_number.blank?
    return phone_import_error(:invalid_phone_number) if implausible?
    return stage_import_error(:invalid_stage) if invalid_stage?
    return update_contact if existing_contact.present?

    create_contact
  end

  def create_contact
    contacts.create(create_params).tap do |contact|
      IceBreaker.call(contact, organization.phone_numbers.first)
      import.contacts_imports.create(contact: contact, updated: false)
    end
  end

  def update_contact
    existing_contact.update(update_params).tap do
      import.contacts_imports.create(contact: existing_contact, updated: true)
    end
  end

  def existing_contact
    @existing_contact ||= begin
      contacts.find_by(id: id) || contact_by_phone_number
    end
  end

  def contact_by_phone_number
    contacts
      .find_by(phone_number: phone_number.phony_normalized(country_code: 'US'))
  end

  def person
    @person ||= Person.create(phone_number: phone_number)
  end

  def create_params
    {
      person: person,
      phone_number: phone_number,
      name: name,
      subscribed: true,
      stage: create_stage
    }
  end

  def create_stage
    stage || organization.contact_stages.first
  end

  def update_params
    params = { phone_number: phone_number }
    params[:name] = name if name.present?
    params[:stage] = stage if stage.present?
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

  def stage
    @stage ||= begin
      return if stage_name.blank?
      organization.contact_stages.find_by(name: stage_name)
    end
  end

  def stage_name
    @stage_name ||= row[stage_mapping.column_number]
  end

  attr_reader :row, :runner, :row_number

  delegate :organization, :phone_number_mapping, :name_mapping,
           :id_mapping, :stage_mapping, :import, to: :runner
  delegate :import_errors, to: :import
  delegate :contacts, to: :organization

  def phone_import_error(error_type)
    import_error(error_type, phone_number_mapping)
  end

  def stage_import_error(error_type)
    import_error(error_type, stage_mapping)
  end

  def import_error(error_type, mapping)
    import_errors.create(
      error_type: error_type,
      row_number: row_number,
      column_number: mapping.column_number,
      column_name: row.headers[mapping.column_number]
    )
  end

  def invalid_stage?
    stage_name.present? &&
      !organization.contact_stages.where(name: stage_name).exists?
  end

  def implausible?
    !phone_number.phony_normalized(country_code: 'US')
  end
end

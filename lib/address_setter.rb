class AddressSetter
  def initialize(candidate, csv: nil)
    @candidate = candidate
    @csv = csv
  end

  def call
    return 'Address present' if candidate.address_feature.present?

    if address_found?
      'Address found'
    else
      'No address found'
    end
  end

  private

  attr_reader :candidate, :csv

  def messages
    @messages ||= candidate.messages
  end

  def create_address(message)
    fake_inquiry = Struct.new(:question).new({})

    address_feature = candidate.candidate_features.create(
      label: question.label,
      properties: AddressQuestion.extract(message, fake_inquiry)
    )
    "Created candidate feature #{address_feature.id}"
  end

  def fetch_row(message)
    new_address = message.address
    row(message, new_address)
  end

  def row(message, new_address)
    [message.id,
     message.body,
     current_address&.formatted_address,
     new_address.address,
     current_address&.id,
     new_address.latitude,
     new_address.longitude,
     new_address.postal_code,
     new_address.country,
     new_address.city]
  end

  def address_feature
    @address_feature ||= candidate.address_feature
  end

  def current_address
    @current_address ||= candidate.address
  end

  def question
    @question ||= survey.questions.find_by(type: 'AddressQuestion')
  end

  def survey
    @survey ||= candidate.organization.survey
  end

  def address_found?
    address_found = false

    messages.each do |message|
      next unless message.address?

      create_or_append_to_csv(csv, message)
      address_found = true
      break
    end

    address_found
  end

  def create_or_append_to_csv(csv, message)
    if csv.present?
      csv << fetch_row(message)
    else
      create_address(message)
    end
  end
end

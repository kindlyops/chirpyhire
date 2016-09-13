class AddressSetter

  def initialize(candidate, csv: nil)
    @candidate = candidate
    @csv = csv
  end

  def call
    return "Address present" if candidate.address_feature.present?
    address_created = false

    messages.map do |message|
      next unless message.has_address?

      if csv.present?
        address_created = true
        row = fetch_row(message)
        csv << row
        row
      else
        address_created = true
        create_address(message)
        break
      end
    end

    if address_created
      "Address created"
    else
      "No address found"
    end
  end

  private

  attr_reader :candidate, :csv

  def messages
    @messages ||= candidate.messages
  end

  def create_address(message)
    fake_inquiry = Struct.new(:question).new({})

    address_feature = candidate.candidate_features.create(label: question.label,
                                                          properties: AddressQuestion.extract(message, fake_inquiry))
    "Created candidate feature #{address_feature.id}"
  end

  def fetch_row(message)
    new_address = message.address

    [message.id,
    message.body,
    current_address.formatted_address,
    new_address.address,
    current_address.id,
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
    @current_address ||= begin
      if address_feature.present?
        Address.new(address_feature)
      else
        NullAddress.new
      end
    end
  end

  def question
    @question ||= survey.questions.find_by(type: "AddressQuestion")
  end

  def survey
    @survey ||= candidate.organization.survey
  end
end



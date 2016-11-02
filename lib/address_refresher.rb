class AddressRefresher
  def initialize(message, csv: nil)
    @message = message
    @csv = csv
  end

  def call
    return 'No address found' unless message.address? && candidate.present?

    if csv.present?
      csv << row
      row
    else
      create_or_update_address
    end
  end

  private

  attr_reader :message, :csv

  def create_or_update_address
    if address_feature.present?
      update_address_feature
    else
      create_address_feature
    end
  end

  def row
    @row ||= [message.id,
              message.body,
              current_address&.formatted_address,
              new_address.address,
              current_address&.id].concat(new_address_elements)
  end

  def new_address_elements
    [
      new_address.latitude,
      new_address.longitude,
      new_address.postal_code,
      new_address.country,
      new_address.city
    ]
  end

  def create_address_feature
    address_feature = candidate.candidate_features.create(
      label: question.label,
      properties: AddressQuestion.extract(message, fake_inquiry)
    )
    "Created candidate feature #{address_feature.id}"
  end

  def update_address_feature
    address_feature.update(
      properties: AddressQuestion.extract(message, fake_inquiry)
    )
    "Updated candidate feature #{address_feature.id}"
  end

  def fake_inquiry
    @fake_inquiry ||= Struct.new(:question).new({})
  end

  def candidate
    @candidate ||= message.user.candidate
  end

  def address_feature
    @address_feature ||= candidate.address_feature
  end

  def current_address
    @current_address ||= candidate.address
  end

  def new_address
    @new_address ||= message.address
  end

  def question
    @question ||= survey.questions.find_by(type: 'AddressQuestion')
  end

  def survey
    @survey ||= candidate.organization.survey
  end
end

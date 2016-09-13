class AddressSetter

  def initialize(message, csv: nil)
    @message = message
    @csv = csv
  end

  def call
    return "Address present" if candidate.address_feature.present?
    return "No address found" unless message.has_address? && candidate.present?

    if csv.present?
      csv << row
      row
    else
      create_address
    end
  end

  private

  attr_reader :message, :csv

  def create_address
    fake_inquiry = Struct.new(:question).new({})

    address_feature = candidate.candidate_features.create(label: question.label,
                                                          properties: AddressQuestion.extract(message, fake_inquiry))
    "Created candidate feature #{address_feature.id}"
  end

  def row
    @row ||= [message.id,
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

  def candidate
    @candidate ||= message.user.candidate
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

  def new_address
    @new_address ||= message.address
  end

  def question
    @question ||= survey.questions.find_by(type: "AddressQuestion")
  end

  def survey
    @survey ||= candidate.organization.survey
  end
end



class AddressRefresher

  def initialize(message, csv: nil)
    @message = message
    @csv = csv
  end

  def call
    return "No address found" unless message.has_address? && candidate.present?

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
      address_feature.update(properties: Address.extract(message, {}))
      "Updated candidate feature #{address_feature.id}"
    else
      address_feature = candidate.candidate_features.create(persona_feature: persona_feature, properties: Address.extract(message, {}))
      "Created candidate feature #{address_feature.id}"
    end
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

  def persona_feature
    @persona_feature ||= candidate_persona.persona_features.find_by(format: "address")
  end

  def candidate_persona
    @candidate_persona ||= candidate.candidate_persona
  end
end



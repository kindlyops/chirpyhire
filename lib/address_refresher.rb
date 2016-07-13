class AddressRefresher

  def initialize(message, csv)
    @message = message
    @csv = csv
  end

  def call
    if message.has_address?
      candidate = message.user.candidate
      return "No address found" unless candidate.present?
      address_feature = candidate.address_feature

      if address_feature.present?
        current_address = Address.new(address_feature)
      else
        current_address = NullAddress.new
      end

      new_address = message.address
      row = [message.id, message.body, current_address.body, new_address.address, current_address.id, new_address.latitude, new_address.longitude, new_address.postal_code, new_address.country, new_address.city]

      csv << row
      row
    else
      "No address found"
    end
  end

  private

  attr_reader :message, :csv
end



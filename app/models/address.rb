class Address < UserFeature
  def self.extract(message)
    address = message.address
    {
      address: address.address,
      latitude: address.latitude,
      longitude: address.longitude,
      postal_code: address.postal_code,
      country: address.country,
      city: address.city,
      child_class: "address"
    }
  end
end

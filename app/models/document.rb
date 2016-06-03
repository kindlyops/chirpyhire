class Document < UserFeature
  def self.extract(message)
    message.images.each_with_object({}).with_index do |(image, properties), index|
      properties["url#{index}"] = "https://api.twilio.com#{image.uri.split('.').first}"
    end
  end
end

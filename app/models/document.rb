class Document < CandidateFeature
  URI_BASE = "https://api.twilio.com"
  def self.extract(message, persona_feature)
    properties = message.images.each_with_object({}).with_index do |(image, properties), index|
      properties["url#{index}".to_sym] = "#{URI_BASE}#{image.uri.split('.').first}"
    end
    properties[:child_class] = "document"
    properties
  end
end

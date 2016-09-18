class DocumentQuestion < Question
  URI_BASE = 'https://api.twilio.com'.freeze
  def self.extract(message, _inquiry)
    properties = fetch_properties(message)
    properties[:child_class] = 'document'
    properties
  end

  def self.fetch_properties(message)
    message.images.each_with_object({}).with_index do |(image, properties), i|
      properties["url#{i}".to_sym] = "#{URI_BASE}#{image.uri.split('.').first}"
    end
  end
end

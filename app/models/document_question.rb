class DocumentQuestion < Question
  URI_BASE = 'https://api.twilio.com'.freeze
  def self.extract_internal(properties, message, _inquiry)
    message.images.each_with_index do |image, i|
      properties["url#{i}".to_sym] = "#{URI_BASE}#{image.uri.split('.').first}"
    end
    properties
  end

  def self.child_class_property
    'document'
  end
end

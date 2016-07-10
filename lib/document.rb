class Document
  URI_BASE = "https://api.twilio.com"
  def self.extract(message, persona_feature)
    properties = message.images.each_with_object({}).with_index do |(image, properties), index|
      properties["url#{index}".to_sym] = "#{URI_BASE}#{image.uri.split('.').first}"
    end
    properties[:child_class] = "document"
    properties
  end

  def initialize(feature)
    @feature = feature
  end

  def first_page
    feature.properties["url0"]
  end

  def uris
    feature.properties.select {|k,_| k["url"] }.values
  end

  def category
    feature.persona_feature.name
  end

  def one_page?
    uris.count == 1
  end

  private

  attr_reader :feature
end

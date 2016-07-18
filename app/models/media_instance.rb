class MediaInstance < ApplicationRecord
  belongs_to :message
  URI_BASE = "https://api.twilio.com"

  IMAGE_TYPES = %w(image/jpeg image/gif image/png image/bmp)

  def image?
    IMAGE_TYPES.include?(content_type)
  end

  def self.images
    where(content_type: IMAGE_TYPES)
  end

  def location
    "#{URI_BASE}#{uri.split('.').first}"
  end
end

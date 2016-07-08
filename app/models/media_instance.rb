class MediaInstance < ApplicationRecord
  belongs_to :message

  IMAGE_TYPES = %w(image/jpeg image/gif image/png image/bmp)

  def image?
    IMAGE_TYPES.include?(content_type)
  end

  def self.images
    where(content_type: IMAGE_TYPES)
  end
end

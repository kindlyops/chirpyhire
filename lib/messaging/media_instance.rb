class Messaging::MediaInstance
  IMAGE_TYPES = %w(image/jpeg image/gif image/png image/bmp).freeze

  def initialize(media_instance)
    @media_instance = media_instance
  end

  def image?
    IMAGE_TYPES.include?(media_instance.content_type)
  end

  delegate :sid, :uri, :content_type, to: :media_instance

  private

  attr_reader :media_instance
end

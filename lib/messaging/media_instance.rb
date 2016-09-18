module Messaging
  class MediaInstance
    IMAGE_TYPES = %w(image/jpeg image/gif image/png image/bmp).freeze

    def initialize(media_instance)
      @media_instance = media_instance
    end

    def image?
      IMAGE_TYPES.include?(media_instance.content_type)
    end

    private

    attr_reader :media_instance

    def method_missing(method, *args, &block)
      media_instance.send(method, *args, &block) || super
    end

    def respond_to_missing?(method_name, include_private = false)
      super
    end
  end
end

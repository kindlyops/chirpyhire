module Messaging
  class Media

    def initialize(media)
      @media = media
    end

    def list
      media.list.map(&method(:wrap))
    end

    def any?(&block)
      media.list.any?(&block)
    end

    private

    attr_reader :media

    def wrap(media_instance)
      Messaging::MediaInstance.new(media_instance)
    end

    def method_missing(method, *args, &block)
      media.send(method, *args, &block)
    end
  end
end

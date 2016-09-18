module Messaging
  class Media
    include Enumerable

    def initialize(media)
      @media = media
    end

    def each(&block)
      list.each(&block)
    end

    private

    attr_reader :media

    def list
      media.list.map(&method(:wrap))
    end

    def wrap(media_instance)
      Messaging::MediaInstance.new(media_instance)
    end
  end
end

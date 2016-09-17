# frozen_string_literal: true
module Constraint
  class Vcard
    MEDIA_TYPES = %w(text/vcard text/directory text/x-vcard text/directory;profile=vCard).freeze

    def matches?(request)
      media_content_types(request).any? do |type|
        MEDIA_TYPES.include?(type)
      end
    end

    private

    def media_content_types(request)
      request.request_parameters.select { |key, _value| key.match(/MediaContentType/) }.values
    end
  end
end

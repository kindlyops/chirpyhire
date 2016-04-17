class VcardConstraint
  MEDIA_TYPES = %w(text/vcard text/directory text/x-vcard text/directory;profile=vCard)

  def matches?(request)
    media_content_types(request).any? do |type|
      MEDIA_TYPES.include?(type)
    end
  end

  private

  def media_content_types(request)
    request.request_parameters.select { |key, value| key.match(/MediaContentType/) }.values
  end
end

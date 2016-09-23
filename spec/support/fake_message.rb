class FakeMessage
  attr_reader :sid, :body, :direction, :date_sent, :date_created, :from, :to, :media

  # rubocop:disable Metrics/ParameterLists
  def initialize(from, to, body, format, direction, sid, exists: true)
    @from = from
    @to = to
    @body = body
    @media = build_media(format)
    @direction = direction
    @date_sent = DateTime.current
    @date_created = DateTime.current
    @sid = sid
    @exists = exists
  end
  # rubocop:enable Metrics/ParameterLists

  def num_media
    raise Twilio::REST::RequestError.new('The requested resource was not found', 20_404) unless exists
    media.list.count.to_s
  end

  def media_urls
    raise Twilio::REST::RequestError.new('The requested resource was not found', 20_404) unless exists
    media.list.map(&:uri)
  end

  def address
    raise Twilio::REST::RequestError.new('The requested resource was not found', 20_404) unless exists
    @address ||= AddressFinder.new(body)
  end

  private

  attr_reader :exists

  MediaInstance = Struct.new(:content_type, :uri) do
    def image?
      %w(image/jpeg image/gif image/png image/bmp).include?(content_type)
    end

    def sid
      Faker::Number.number(10)
    end
  end

  Media = Struct.new(:media_instances) do
    def list
      media_instances
    end
  end

  def build_media(format)
    if format == :text
      Media.new([])
    elsif format == :image
      Media.new([MediaInstance.new('image/jpeg', '/example/path/to/image.png')])
    end
  end
end

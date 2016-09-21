class FakeMessage
  attr_reader :sid, :body, :direction, :date_sent, :date_created, :from, :to, :media

  # rubocop:disable Metrics/ParameterLists
  def initialize(from, to, body, media, direction, date_sent, date_created, sid, exists: true)
    @from = from
    @to = to
    @body = body
    @media = media
    @direction = direction
    @date_sent = date_sent
    @date_created = date_created
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
end

class Sms::Message
  attr_reader :sid

  def initialize(url:, sid:)
    @url = url
    @sid = sid
  end

  def vcard
    Vcard.new(url: url)
  end

  private

  attr_reader :url
end

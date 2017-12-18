class Bot::ZipcodeAnswer
  def initialize(follow_up)
    @follow_up = follow_up
  end

  attr_reader :follow_up

  def activated?(message)
    zipcode = parse_zipcode(message)

    zipcode.present? && fetch_zipcode(message, zipcode)
  end

  private

  def fetch_zipcode(message, zipcode)
    ZipcodeFetcher.call(message.contact, zipcode, location: follow_up.location?)
  end

  def zipcode_regexp
    /\A(\d{5})\z/
  end

  def parse_zipcode(message)
    result = zipcode_regexp.match(clean_body(message))
    return if result.blank?

    result[1]
  end

  def clean_body(message)
    message.body.lines.first.strip.downcase
  end
end

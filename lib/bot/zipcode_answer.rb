class Bot::ZipcodeAnswer
  def initialize(follow_up)
    @follow_up = follow_up
  end

  attr_reader :follow_up

  def activated?(message)
    zipcode = fetch_zipcode(message)

    zipcode.present? && ZipcodeFetcher.call(message.contact, zipcode)
  end

  private

  def zipcode_regexp
    /\A(\d{5})\z/
  end

  def fetch_zipcode(message)
    result = zipcode_regexp.match(clean_body(message))
    return if result.blank?

    result[1]
  end

  def clean_body(message)
    message.body.strip.downcase
  end
end

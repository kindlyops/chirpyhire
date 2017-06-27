class Answer::Zipcode < Answer::Base
  def valid?(message)
    zipcode = fetch_zipcode(message)

    zipcode.present? && !!ZipcodeFetcher.call(contact, zipcode)
  end

  def attribute(message)
    { zipcode: fetch_zipcode(message) }
  end

  private

  delegate :contact, to: :question

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

class Answer::Zipcode < Answer::Base
  ZIPCODE_REGEXP = /\A(\d{5})\z/

  def valid?(message)
    cleaned_body = message.body.strip.downcase
    zipcode = ZIPCODE_REGEXP.match(cleaned_body)[1]

    zipcode.present? && ZipCodes.identify(zipcode).present?
  end
end

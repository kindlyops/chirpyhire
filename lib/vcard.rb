class Vcard

  def initialize(url:)
    @url = url
  end

  def phone_number
    PhonyRails.normalize_number(card.tel.first.value, country_code: 'US')
  end

  def first_name
    name.given
  end

  def last_name
    name.family
  end

  def attributes
    {
      phone_number: phone_number,
      first_name: first_name,
      last_name: last_name
    }
  end

  private

  attr_reader :card, :url

  def card
    @card ||= VCardigan.parse(response)
  end

  def response
    HTTParty.get(url)
  end

  def name
    Namae.parse(card.fn.first.value).first
  end
end

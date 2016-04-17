class Vcard

  def initialize(url:)
    @card = fetch_card(url)
  end

  def phone_number
    Phony.normalize(card.tel.first.value)
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

  attr_reader :card

  def fetch_card(url)
    VCardigan.parse(HTTParty.get(url))
  end

  def name
    Namae.parse(vcard.fn.first.value).first
  end
end

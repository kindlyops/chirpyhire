class Message < ActiveRecord::Base
  belongs_to :organization

  def vcard
    return NullVcard unless media_url.present?
    Vcard.new(url: media_url)
  end
end

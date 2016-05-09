class Message < ActiveRecord::Base
  belongs_to :user
  has_one :notification
  has_one :inquiry
  has_one :answer

  def vcard
    return NullVcard unless media_url.present?
    Vcard.new(url: media_url)
  end
end

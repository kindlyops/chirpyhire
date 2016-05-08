class Message < ActiveRecord::Base
  belongs_to :organization
  belongs_to :user

  enum status: [:outgoing, :incoming]

  def vcard
    return NullVcard unless media_url.present?
    Vcard.new(url: media_url)
  end
end

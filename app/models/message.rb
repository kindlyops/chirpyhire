class Message < ActiveRecord::Base
  belongs_to :organization

  def vcard
    Vcard.new(url: media_url)
  end
end

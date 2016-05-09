class Message < ActiveRecord::Base
  belongs_to :user
  has_many :notifications
  has_many :inquiries

  enum category: [:question, :answer, :notice]

  def vcard
    return NullVcard unless media_url.present?
    Vcard.new(url: media_url)
  end
end

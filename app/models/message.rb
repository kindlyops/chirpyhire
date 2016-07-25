class Message < ApplicationRecord
  has_many :media_instances

  belongs_to :user
  has_one :inquiry
  has_one :answer
  has_one :notification
  belongs_to :child, class_name: "Message"
  delegate :organization, to: :user

  def self.by_recency
    order(external_created_at: :desc, id: :desc)
  end

  def self.by_read_status
    joins(:user).merge(User.by_having_unread_messages)
  end

  def self.conversations
    where(child: nil)
  end

  def media
    media_instances
  end

  def images
    media_instances.images
  end

  def inbound?
    direction == "inbound"
  end

  def has_images?
    return media_instances.any?(&:image?) unless persisted?
    media_instances.images.present?
  end

  def has_address?
    return false unless body.present?
    address.found?
  end

  def has_choice?(choices)
    return false unless body.present? && choices.present?
    Regexp.new("\\A([#{choices}]){1}\\)?\\z") === body.strip.downcase
  end

  def address
    @address ||= AddressFinder.new(body)
  end
end

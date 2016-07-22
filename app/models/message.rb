class Message < ApplicationRecord
  has_many :media_instances

  belongs_to :user
  has_one :inquiry
  has_one :answer
  has_one :notification
  delegate :organization, to: :user

  def self.by_recency
    order(external_created_at: :desc, id: :desc)
  end

  def self.conversations
    select("DISTINCT ON (messages.user_id) messages.user_id, messages.*").order(:user_id, id: :desc)
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

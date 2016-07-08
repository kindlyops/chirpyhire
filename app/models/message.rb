class Message < ApplicationRecord
  MESSAGEABLES = %w(Notification Chirp Answer Inquiry)
  has_many :media_instances
  belongs_to :messageable, polymorphic: true
  validates :messageable_type, inclusion: { in: MESSAGEABLES }

  def media
    media_instances
  end

  def has_images?
    return media_instances.any?(&:image?) unless persisted?
    media_instances.images.present?
  end

  def has_address?
    return false unless body.present?
    address.found?
  end

  def has_choice?
    return false unless body.present?
    /\A([a-z]){1}\)?\z/ === body.strip.downcase
  end

  def address
    @address ||= AddressFinder.new(body)
  end

  def images
    media_instances.images
  end
end

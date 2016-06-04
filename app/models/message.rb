class Message < ActiveRecord::Base
  belongs_to :user
  has_many :tasks, as: :taskable
  has_many :media_instances
  belongs_to :messageable, polymorphic: true

  delegate :organization, to: :user
  delegate :name, to: :sender, prefix: true

  def sender
    @sender ||= begin
      if direction == "outbound-api"
        organization
      elsif direction == "inbound"
        user
      end
    end
  end

  def recipient
    @recipient ||= begin
      if direction == "outbound-api"
        user
      elsif direction == "inbound"
        organization
      end
    end
  end

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

  def address
    @address ||= AddressFinder.new(body)
  end

  def images
    media_instances.images
  end

  def outstanding_task
    tasks.outstanding.first
  end
end

class Message < ActiveRecord::Base
  belongs_to :user
  has_many :tasks, as: :taskable
  has_many :media_instances
  has_one :inquiry
  has_one :notification
  has_one :answer

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

  def media
    media_instances
  end

  def has_images?
    media_instances.images.present?
  end

  def images
    media_instances.images
  end
end

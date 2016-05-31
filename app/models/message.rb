class Message < ActiveRecord::Base
  belongs_to :user
  has_many :tasks, as: :taskable
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

  def body
    message.body
  end

  def direction
    message.direction
  end

  def media
    message.media
  end

  def has_images?
    media.any?(&:image?)
  end

  def images
    media.select(&:image?)
  end

  private

  def message
    @message ||= organization.get_message(sid)
  end
end

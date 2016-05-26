class Message < ActiveRecord::Base
  belongs_to :user
  has_one :inquiry
  has_one :notification
  has_one :answer
  has_one :task

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

  private

  def message
    @message ||= organization.messages.get(sid)
  end
end

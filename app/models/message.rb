class Message < ActiveRecord::Base
  belongs_to :user
  has_one :inquiry
  has_one :notification
  has_one :answer

  delegate :organization, to: :user

  def sender
    @sender ||= begin
      if inquiry || notification
        organization
      else
        user
      end
    end
  end

  def media
    message.media
  end

  def relay
    return if sid.present?
    message = user.receive_message(body: body)
    update(sid: message.sid)
  end

  private

  def message
    @message ||= organization.messages.get(sid)
  end
end

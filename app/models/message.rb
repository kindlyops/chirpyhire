class Message < ActiveRecord::Base
  belongs_to :user
  has_one :inquiry
  has_one :notification
  has_one :answer

  delegate :organization, to: :user

  def sender
    if inquiry || notification
      organization
    else
      user
    end
  end

  def media
    message.media
  end

  private

  def message
    @message ||= organization.messages.get(sid)
  end
end

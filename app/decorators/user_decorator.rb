class UserDecorator < Draper::Decorator
  delegate_all
  decorates_association :candidate

  def phone_number
    if object.phone_number
      object.phone_number.phony_formatted
    else
      ""
    end
  end

  def send_message_title
    return unless user.cannot_receive_messages?

    "You've reached your message limit. Please upgrade to send more messages."
  end
end

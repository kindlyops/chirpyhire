class ConversationDecorator < Draper::Decorator
  delegate_all

  def last_reply
    return 'The conversation is just beginning!' if messages.empty?
    "Last reply #{conversation.last_reply_at}"
  end

  def empty_state_message
    'To start the conversation, type your message in the box below '\
    "and then click 'Message'. We hope #{conversation.person_handle} "\
    'is a great fit!'
  end

  def last_reply_at
    return "at #{last_reply_at_clock_time}" if recently_replied?

    time_ago = h.time_ago_in_words(object.last_reply_at)
    "#{time_ago} ago at #{last_reply_at_clock_time}"
  end

  def last_reply_at_clock_time
    object.last_reply_at.strftime('%I:%M %P')
  end
end

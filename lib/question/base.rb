class Question::Base < Notification::Base
  def body(welcome: false)
    return '' unless welcome
    "#{welcome_notification}\n\n"
  end

  private

  def welcome_notification
    Notification::Welcome.new(contact).body
  end
end

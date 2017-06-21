class Notification::Welcome < Notification::Base
  def body
    <<~BODY.strip
      Hey there! #{organization.sender_notice}
      Want to join the #{organization.name} team?
      Well, let's get started.
      Please tell us more about yourself.
    BODY
  end
end

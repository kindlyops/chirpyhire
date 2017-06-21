class Notification::CompleteWelcome < Notification::Base
  def body
    <<~BODY.strip
      Hey there! #{organization.sender_notice}
      Want to join the #{organization.name} team?

      You've just taken the first step!

      If you don't hear back in a day or two, would you please text us back??

      We are incredibly busy helping caregivers help more families!
    BODY
  end
end

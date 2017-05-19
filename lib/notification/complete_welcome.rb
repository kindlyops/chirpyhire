class Notification::CompleteWelcome < Notification::Base
  def body
    <<~BODY.strip
      Hey there! #{sender_notice}
      Want to join the #{organization.name} team?

      You've just taken the first step!

      If you don't hear back in a day or two, would you please text us back??

      We are incredibly busy helping caregivers help more families!
    BODY
  end

  def sender_notice
    return recruiter_notice if recruiter && recruiter.first_name
    "This is #{organization.name}."
  end

  def recruiter_notice
    "This is #{recruiter.first_name} with #{organization.name}."
  end
end

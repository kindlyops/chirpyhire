class Notification::Welcome < Notification::Base
  def body
    <<~BODY
      Hey there! #{sender_notice}
      Want to join a team of "Chirpy" Caregivers? Well, let's get started. \
Please tell us more about yourself.
    BODY
  end

  def sender_notice
    return recruiter_notice if recruiter.first_name.present?
    "This is #{organization.name}."
  end

  def recruiter_notice
    "This is #{recruiter.first_name} with #{organization.name}."
  end
end

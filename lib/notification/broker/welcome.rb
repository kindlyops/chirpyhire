class Notification::Broker::Welcome < Notification::Broker::Base
  def body
    <<~BODY.strip
      Hey there! #{sender_notice}
      Want to join a team of "Chirpy" Caregivers?
      Well, let's get started.
      Please tell us more about yourself.
    BODY
  end

  def sender_notice
    'This is Wayne with ChirpyHire'
  end
end

class Notification::Welcome < Notification::Base
  def body
    <<~BODY
      Hello, this is #{organization.name}.
      We are hiring for multiple job openings!
      We are so glad you're interested in immediate
      work opportunities in the #{organization.city} area.

      We have a few questions to ask you via text message.
      We will give you a call to confirm at our earliest opportunity!
    BODY
  end
end

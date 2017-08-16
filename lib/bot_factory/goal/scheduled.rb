class BotFactory::Goal::Scheduled < BotFactory::Goal
  def body
    <<~GOAL.strip
      Ok. Great! We're all set. Here's a link with directions to our office: #{directions}

      Please make sure to bring your:
      Driver’s License
      Social Security
      Any Certifications: HHA CNA, MA or LPN
      2 Step TB
      Copy of Background Check
      Any work references you might have

      Oh... one more thing. I forgot to ask, what's your name? 😊
    GOAL
  end

  def stage
    @stage ||= organization.contact_stages.find_by(name: 'Scheduled')
  end

  def directions
    'TODO ADD DIRECTIONS'
  end
end

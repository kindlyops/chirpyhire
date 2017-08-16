class BotFactory::Goal::NotNow < BotFactory::Goal
  def body
    <<~GOAL.strip
      I'm sorry, but you don't meet our requirements so we can't move further.

      Text me back once you've got your requirements covered and we'll go from there!

      In the meantime, if I can answer any questions please let me know! Have a great day! 😊
    GOAL
  end

  def stage
    @stage ||= organization.contact_stages.find_by(name: 'Not Now')
  end
end

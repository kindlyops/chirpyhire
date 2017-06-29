class BotMaker::DefaultBot

  def initialize(organization)
    @organization = organization
  end

  def call
    return if organization.bots.where(name: 'chirpy').exists?

    bot.create_greeting(body: greeting_body)
    create_questions

    bot.goals.create(body: goal_body)
  end

  attr_reader :organization

  def create_questions
    BotMaker::Question::Certification.call(bot, rank: 1)
    BotMaker::Question::Availability.call(bot, rank: 2)
    BotMaker::Question::LiveIn.call(bot, rank: 3)
    BotMaker::Question::Experience.call(bot, rank: 4)
    BotMaker::Question::Transportation.call(bot, rank: 5)
    BotMaker::Question::DriversLicense.call(bot, rank: 6)
    BotMaker::Question::ZipcodeQuestion.call(bot, rank: 7)
    BotMaker::Question::CprFirstAid.call(bot, rank: 8)
    BotMaker::Question::SkinTest.call(bot, rank: 9)
  end

  def bot
    @bot ||= organization.bots.create(name: 'chirpy', keyword: 'start')
  end

  def greeting_body
    <<~BODY.strip
      Hey there! #{organization.sender_notice}
      Want to join the #{organization.name} team?
      Well, let's get started.
      Please tell us more about yourself.
    BODY
  end

  def goal_body
    <<~BODY
      Ok. Great! We're all set. Now, let us get you the right opportunity!

      If you don't hear back in a day or two, please text us back.

      Oh... one more thing. I forgot to ask, what's your name? :)
    BODY
  end

end

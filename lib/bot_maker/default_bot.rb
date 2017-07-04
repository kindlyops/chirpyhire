class BotMaker::DefaultBot
  DEFAULT_NAME = 'Chirpy'.freeze

  def self.call(organization)
    new(organization).call
  end

  def initialize(organization)
    @organization = organization
  end

  def call
    existing_bot = organization.bots.find_by(name: DEFAULT_NAME)
    return existing_bot if existing_bot.present?

    bot.create_greeting(body: greeting_body)
    create_goal_tags
    create_questions
    bot
  end

  attr_reader :organization

  def create_goal_tags
    goal.tags << organization.tags.find_or_create_by(name: 'Screened')
  end

  def goal
    @goal ||= bot.goals.create(body: goal_body, rank: bot.next_goal_rank)
  end

  def create_questions
    questions.each_with_index do |klass, index|
      "BotMaker::Question::#{klass}".constantize.call(bot, rank: index + 1)
    end
  end

  def questions
    %w[Certification Availability LiveIn Experience Transportation
       DriversLicense Zipcode CprFirstAid SkinTest]
  end

  def bot
    @bot ||= organization.bots.create(name: DEFAULT_NAME, person: bot_person)
  end

  def bot_person
    Person.find_or_create_by(name: DEFAULT_NAME)
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

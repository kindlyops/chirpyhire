class BotFactory::Maker
  NAME = 'Chirpy'.freeze

  def self.call(a, name: NAME, team_name: nil, notice: nil)
    new(a, name: name, team_name: team_name, notice: notice).call
  end

  def initialize(account, name:, team_name:, notice:)
    @account = account
    @name = name
    @team_name = team_name
    @notice = notice
  end

  def call
    existing_bot = organization.bots.find_by(name: name)
    return existing_bot if existing_bot.present?

    create_goals
    create_greeting
    create_questions
    bot
  end

  def team_name
    @team_name ||= organization.name
  end

  def notice
    @notice ||= organization.sender_notice
  end

  attr_reader :account, :name
  delegate :organization, to: :account

  def create_greeting
    bot.create_greeting(body: greeting_body)
  end

  def self.goals
    %w[Scheduled NotNow]
  end

  def goals
    self.class.goals
  end

  def create_goals
    goals.each_with_index do |klass, index|
      "BotFactory::Goal::#{klass}".constantize.call(bot, rank: index + 1)
    end
  end

  def create_questions
    questions.each_with_index do |klass, index|
      "BotFactory::Question::#{klass}".constantize.call(bot, rank: index + 1)
    end
  end

  def self.questions
    %w[Certification WeekDay TimeOfDay]
  end

  def questions
    self.class.questions
  end

  def bot
    @bot ||= begin
      organization.bots.create(
        name: name,
        person: bot_person,
        account: account,
        last_edited_by: account,
        last_edited_at: DateTime.current
      )
    end
  end

  def bot_person
    Person.find_or_create_by(name: name)
  end

  def greeting_body
    <<~BODY.strip
      Hey there! #{notice}
      Want to join the #{team_name} team?
      Well, let's get started.
      Please tell us more about yourself.
    BODY
  end
end

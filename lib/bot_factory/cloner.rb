class BotFactory::Cloner
  def self.call(bot)
    new(bot).call
  end

  def initialize(bot)
    @bot = bot
  end

  attr_reader :bot
  delegate :organization, :person, :greeting, :questions, :goals, to: :bot

  def call
    cloned_bot.tap do |clone|
      clone_greeting(clone)
      clone_questions(clone)
      clone_goals(clone)
    end
  end

  def clone_greeting(clone)
    clone.create_greeting(body: greeting.body)
  end

  def clone_questions(clone)
    questions.find_each { |question| clone_question(clone, question) }
  end

  def clone_goals(clone)
    goals.find_each { |goal| clone_goal(clone, goal) }
  end

  def clone_goal(clone, goal)
    clone.goals.create(
      body: goal.body,
      rank: goal.rank,
      outcome: goal.outcome,
      contact_stage: goal.contact_stage
    )
  end

  def clone_question(clone, question)
    cloned_question = clone.questions.create(
      body: question.body(formatted: false),
      active: question.active,
      type: question.type,
      rank: question.rank
    )

    question.follow_ups.find_each do |follow_up|
      clone_follow_up(cloned_question, follow_up)
    end
  end

  def clone_follow_up(question, follow_up)
    cloned_follow_up = question.follow_ups.create(
      follow_up_attributes(follow_up)
    )

    follow_up.tags.find_each { |tag| clone_tag(cloned_follow_up, tag) }
  end

  def follow_up_attributes(follow_up)
    {
      body: follow_up.body, action: follow_up.action,
      type: follow_up.type,
      next_question: follow_up.next_question,
      goal: follow_up.goal,
      rank: follow_up.rank,
      response: follow_up.response,
      location: follow_up.location,
      deleted_at: follow_up.deleted_at
    }
  end

  def clone_tag(taggable, tag)
    taggable.tags << tag
  end

  def cloned_bot
    @cloned_bot ||= organization.bots.create(name: cloned_name, person: person)
  end

  def cloned_name
    loop.with_index do |_, i|
      cloned_name = next_name(i)
      return cloned_name unless taken?(cloned_name)
    end
  end

  def taken?(name)
    organization.bots.where(name: name).exists?
  end

  def next_name(i)
    "#{bot.name} Clone: #{i}"
  end
end

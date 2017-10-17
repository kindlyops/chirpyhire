class BotFactory::Cloner
  def self.call(bot, account)
    new(bot, account).call
  end

  def initialize(bot, account)
    @bot = bot
    @account = account
  end

  attr_reader :bot, :account
  delegate :greeting, :ranked_questions, :ranked_goals, to: :bot
  delegate :organization, to: :account

  def call
    cloned_bot.tap do |clone|
      clone_greeting(clone)
      clone_goals(clone)
      clone_questions(clone)
      clone_follow_ups(clone)
    end
  end

  def clone_greeting(clone)
    clone.create_greeting(body: greeting.body)
  end

  def clone_follow_ups(clone)
    ranked_questions.find_each do |question|
      clone_question_follow_ups(clone, question)
    end
  end

  def clone_questions(clone)
    ranked_questions.find_each { |question| clone_question(clone, question) }
  end

  def clone_goals(clone)
    ranked_goals.find_each { |goal| clone_goal(clone, goal) }
  end

  def clone_question_follow_ups(clone, question)
    cloned_question = clone.questions.find_by(
      body: question.body(formatted: false),
      active: question.active,
      type: question.type,
      rank: question.rank
    )

    question.follow_ups.find_each do |follow_up|
      clone_follow_up(cloned_question, follow_up)
    end
  end

  def clone_goal(clone, goal)
    clone.goals.create(
      body: goal.body,
      rank: goal.rank,
      alert: goal.alert,
      contact_stage: goal.contact_stage
    ).tap do |cg|
      cloned_bot.actions.create(type: 'GoalAction', goal_id: cg.id)
    end
  end

  def clone_question(clone, question)
    clone.questions.create(
      body: question.body(formatted: false),
      active: question.active,
      type: question.type,
      rank: question.rank,
      deleted_at: question.deleted_at
    ).tap do |cq|
      cloned_bot.actions.create(type: 'QuestionAction', question_id: cq.id)
    end
  end

  def clone_follow_up(question, follow_up)
    action = follow_up.action

    if action.is_a?(GoalAction)
      goal = action.goal
      cloned_goal = cloned_bot.goals.find_by(
        body: goal.body,
        rank: goal.rank,
        alert: goal.alert,
        contact_stage: goal.contact_stage
      )

      cloned_action = cloned_goal.action
    elsif action.is_a?(QuestionAction)
      question = action.question
      cloned_question = cloned_bot.questions.find_by(
        body: question.body(formatted: false),
        active: question.active,
        type: question.type,
        rank: question.rank,
        deleted_at: question.deleted_at
      )

      cloned_action = cloned_question.action
    else
      cloned_action = cloned_bot.next_question_action
    end

    cloned_follow_up = question.follow_ups.create(
      follow_up_attributes(follow_up, cloned_action)
    )

    follow_up.tags.find_each { |tag| clone_tag(cloned_follow_up, tag) }
  end

  def follow_up_attributes(follow_up, action)
    {
      body: follow_up.body,
      type: follow_up.type,
      rank: follow_up.rank,
      action: action,
      response: follow_up.response,
      location: follow_up.location,
      deleted_at: follow_up.deleted_at
    }
  end

  def clone_tag(taggable, tag)
    taggable.tags << tag
  end

  def cloned_bot
    @cloned_bot ||= begin
      organization.bots.create(
        account: account,
        name: cloned_name,
        person: Person.create,
        last_edited_by: account,
        last_edited_at: DateTime.current
      )
    end
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

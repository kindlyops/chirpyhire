class Conversation::Day

  def initialize(day)
    @date, @messages = day
    @current_thought = 1
  end

  attr_reader :date, :messages
  attr_accessor :current_thought

  def thoughts
    @thoughts ||= messages.group_by.with_index(&method(:thought)).map(&method(:to_thought))
  end

  def label
    return 'Today' if today?
    return 'Yesterday' if yesterday?
    return short_format if current_year?
    long_format
  end

  private

  def today?
    date == Date.current
  end

  def yesterday?
    date == Date.yesterday
  end

  def current_year?
    date > Date.current.beginning_of_year
  end

  def short_format
    date.strftime("%B #{date.day.ordinalize}")
  end

  def long_format
    date.strftime("%B #{date.day.ordinalize}, %Y")
  end

  def thought(message, index)
    return [message.author, self.current_thought] if index.zero?
    last_message = messages[index - 1]

    if same_thought?(message, last_message)
      [message.author, self.current_thought]
    else
      [message.author, self.current_thought += 1]
    end
  end

  def to_thought(thought)
    Conversation::Thought.new(thought)
  end

  def same_thought?(first, second)
    same_author?(first, second) && within_five_minutes?(first, second)
  end

  def same_author?(first, second)
    first.author == second.author
  end

  def within_five_minutes?(first, second)
    first.external_created_at - second.external_created_at < 5.minutes
  end
end

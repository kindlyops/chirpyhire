class Bot::ChoiceAnswer
  delegate :choice, to: :follow_up

  def initialize(follow_up)
    @follow_up = follow_up
  end

  attr_reader :follow_up

  def multiple_choice_regexp
    Regexp.new("\\A([#{choice}])(\\z|[\\W]+.*\\z)")
  end

  def activated?(message)
    choice == fetch_choice(message)
  end

  private

  def fetch_choice(message)
    return if match(message).blank?
    match(message)[1].to_sym
  end

  def match(message)
    multiple_choice_regexp.match(clean(message.body))
  end

  def clean(string)
    string.downcase.squish
  end
end

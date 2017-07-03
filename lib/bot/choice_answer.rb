class Bot::ChoiceAnswer
  delegate :choice, to: :follow_up

  def initialize(follow_up)
    @follow_up = follow_up
  end

  attr_reader :follow_up

  def activated?(message)
    choice?(message)
  end

  private

  def choice?(message)
    choice.to_s == clean(message.body)
  end

  def clean(string)
    string.downcase.squish
  end
end

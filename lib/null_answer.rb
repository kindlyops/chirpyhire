# frozen_string_literal: true
NullAnswer = Naught.build do |config|
  config.mimic Answer

  def question
    NullQuestion.new
  end
end

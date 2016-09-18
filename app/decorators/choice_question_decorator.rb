class ChoiceQuestionDecorator < Draper::Decorator
  delegate_all

  def label_placeholder
    'Availability'
  end

  def text_placeholder
    'What is your availability?'
  end
end

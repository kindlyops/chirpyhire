class ChoiceQuestionDecorator < Draper::Decorator
  delegate_all

  def label_placeholder
    "Transportation"
  end

  def text_placeholder
    "Can you drive?"
  end
end

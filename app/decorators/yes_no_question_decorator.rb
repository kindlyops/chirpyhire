# frozen_string_literal: true
class YesNoQuestionDecorator < Draper::Decorator
  delegate_all

  def label_placeholder
    'Transportation'
  end

  def text_placeholder
    'Can you drive?'
  end
end

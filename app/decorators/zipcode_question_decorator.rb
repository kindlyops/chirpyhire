class ZipcodeQuestionDecorator < Draper::Decorator
  delegate_all

  def label_placeholder
    'Zipcode'
  end

  def text_placeholder
    'What is your 5-digit zipcode?'
  end
end

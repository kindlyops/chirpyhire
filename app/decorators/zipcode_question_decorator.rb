class ZipcodeQuestionDecorator < Draper::Decorator
  delegate_all

  def extra_information_noun
    'zipcodes'
  end

  def label_placeholder
    'Zipcode'
  end

  def text_placeholder
    'What is your 5-digit zipcode?'
  end
end

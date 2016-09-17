# frozen_string_literal: true
class AddressQuestionDecorator < Draper::Decorator
  delegate_all

  def label_placeholder
    'Address'
  end

  def text_placeholder
    'What is your street address and zipcode?'
  end
end

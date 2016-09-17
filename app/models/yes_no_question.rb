# frozen_string_literal: true
class YesNoQuestion < Question
  REGEXP = /\A(yes|no|y|n)\z/
  def self.extract(message, inquiry)
    question = inquiry.question

    properties = {}
    properties[:child_class] = 'yes_no'

    answer = message.body.strip.downcase
    yes_no_option = YesNoQuestion::REGEXP.match(answer)[1]

    options = {
      y: 'Yes',
      yes: 'Yes',
      no: 'No',
      n: 'No'
    }

    properties[:yes_no_option] = options[yes_no_option.to_sym]
    properties
  end

  def rejects?(candidate)
    feature = candidate.candidate_features.where(label: label).where("properties->>'child_class' = ?", 'yes_no').first
    feature['properties']['yes_no_option'] == 'No'
  end

  def formatted_text
    <<-template
#{text}

Please reply with just Yes or No.
template
  end
end
